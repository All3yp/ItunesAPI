//
//  Service.swift
//  APIPersistence
//
//  Created by Alley Pereira on 19/03/22.
//

import Foundation

protocol ServiceProtocol {

	func get<T: Decodable>(
		_ endpoint: URL,
		of type: T.Type,
		completion: @escaping (Result<T, Service.ServiceError>) -> Void)
}

final class Service: ServiceProtocol {

	let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func get<T: Decodable>(_ endpoint: URL, of type: T.Type, completion: @escaping (Result<T, ServiceError>) -> Void) {

		var request = URLRequest(url: endpoint)
		request.httpMethod = "GET"

		session.dataTask(with: request) { data, _, error in
			do {
				if let error = error {
					completion(.failure(.requestFailed(description: error.localizedDescription)))
					return
				}

				guard let data = data, !data.isEmpty else {
					completion(.failure(.emptyData))
					return
				}

				let json = try JSONDecoder().decode(T.self, from: data)
				completion(.success(json))

			} catch {
				print("❌ Decode error", error)
				completion(.failure(.decodeError))
			}
		}
		.resume()
	}


}

