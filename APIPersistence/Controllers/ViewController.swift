//
//  ViewController.swift
//  APIPersistence
//
//  Created by Alley Pereira on 19/03/22.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var responseTextView: UITextView!
	@IBAction func resultButton(_ sender: UIButton) {
		debug()
	}

	// MARK: You can use this example for fetching Albuns and get the model on the views

	func debug() {

		let api = GetMusicService()

		api.fetchAlbuns { [weak self] result in
			DispatchQueue.main.async {
				self?.responseTextView.text = result!.results.description
			}
		}
	}
}
