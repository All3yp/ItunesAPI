//
//  GetMusicService.swift
//  APIPersistence
//
//  Created by Alley Pereira on 19/03/22.
//

import Foundation

protocol GetMusicServiceProtocol {
	var network: ServiceProtocol { get }
	func fetchAlbuns(_ completion: @escaping (Welcome?) -> Void)
}

struct GetMusicService: GetMusicServiceProtocol {

	var network: ServiceProtocol = Service()

	func fetchAlbuns(_ completion: @escaping (Welcome?) -> Void) {

		let endpoint = "https://run.mocky.io/v3/283a8e2d-e125-486f-bed5-bf8a5fac4cd7"

		guard let url = URL(string: endpoint) else { return }

		network.get(url, of: Welcome.self) { result in
			switch result {
				case .success(let result):
					completion(result)
				case .failure:
					completion(nil)
			}
		}
	}

}
