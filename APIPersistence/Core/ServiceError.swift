//
//  ServiceError.swift
//  APIPersistence
//
//  Created by Alley Pereira on 19/03/22.
//

import Foundation

extension Service {
	enum ServiceError {
		case emptyData
		case decodeError
		case requestFailed(description: String)
	}
}

extension Service.ServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
			case .emptyData:
				return "No error was received but we also don't have data."
			case .decodeError:
				return "Could not decoded result"
			case .requestFailed(description: let description):
				return "Could not run request because: \(description)"
		}
	}
}
