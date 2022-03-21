//
//  ManagedObjectContext.swift
//  AppCoreData
//
//  Created by SP11601 on 19/03/22.
//

import Foundation
import UIKit
import CoreData

typealias onCompletionHandler = (String) -> Void

protocol managedProtocol {
	func getAlbuns() -> [Album]
}

protocol managedSaveProtocol {
	func save(album: Album, onCompletionHandler: onCompletionHandler)
}

protocol managedDeleteProtocol {
	func delete(uuid: String, onCompletionHandler: onCompletionHandler)
}

class ManagedObjectContext: managedProtocol, managedSaveProtocol, managedDeleteProtocol {

	private let entity = "Albuns"

	func getContext() -> NSManagedObjectContext {

		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.persistentContainer.viewContext

	}

	func getAlbuns() -> [Album] {
		var albunsList: [Album] = []
		let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)

		do {
			guard let albuns = try getContext().fetch(fetchRequest) as? [NSManagedObject] else { return albunsList }

			for item in albuns {

				if let id = item.value(forKey: "id") as? UUID,
				   let artistName = item.value(forKey: "artistName") as? String,
				   let artworkUrl100 = item.value(forKey: "artworkUrl100") as? String,
				   let collectionName = item.value(forKey: "collectionName") as? String,
				   let collectionViewURL = item.value(forKey: "collectionViewURL") as? String,
				   let trackNamesAsAString = item.value(forKey: "trackNames") as? String {

					// TRANSFORMA A STRING QUE CONTEM TODAS AS MUSICAS JUNTAS EM UM ARRAY DE MUSICAS SEPARADAS
					let trackNamesAsAnArray = trackNamesAsAString.components(separatedBy: "\n")

					let album = Album(id: id, artistName: artistName, artworkUrl100: artworkUrl100, collectionName: collectionName, collectionViewURL: collectionViewURL, trackNames: trackNamesAsAnArray)

					albunsList.append(album)
				}

			}

		} catch let error as NSError {
			print("Error in request \(error.localizedDescription)")
		}

		return albunsList
	}

	func save(album: Album, onCompletionHandler: (String) -> Void) {

		let context = getContext()
		guard let entity = NSEntityDescription.entity(forEntityName: entity, in: context) else { return }
		let transaction = NSManagedObject(entity: entity, insertInto: context)

		// PERCORRER O ARRAY Album.trackNames E CONCATENAR OS ELEMENTOS EM UMA UNICA STRING trackNamesAsAString
		var trackNamesAsAString = ""
		for item in album.trackNames {
			let barraN = "\n"
			trackNamesAsAString += item + barraN
		}

		transaction.setValue(album.id, forKey: "id")
		transaction.setValue(album.artistName, forKey: "artistName")
		transaction.setValue(album.artworkUrl100, forKey: "artworkUrl100")
		transaction.setValue(album.collectionName, forKey: "collectionName")
		transaction.setValue(album.collectionViewURL, forKey: "collectionViewURL")
		transaction.setValue(trackNamesAsAString, forKey: "trackNames")

		do {
			try context.save()
			onCompletionHandler("Save Success")

		} catch let error as NSError {
			print("Could not save \(error.localizedDescription)")
		}

	}

	func delete(uuid: String, onCompletionHandler: (String) -> Void) {

		let context = getContext()
		let predicate = NSPredicate(format: "id == %@","\(uuid)")
		let fetchRequest: NSFetchRequest<NSFetchRequestResult>=NSFetchRequest(entityName: entity)

		fetchRequest.predicate = predicate

		do {
			let fetchResult = try context.fetch(fetchRequest) as! [NSManagedObject]

			if let entityDelete = fetchResult.first {
				context.delete(entityDelete)
			}

			try context.save()

			onCompletionHandler("Delete Success")

		} catch let error as NSError {

			print("Fetch failed \(error.localizedDescription)")

		}
	}

}
