//
//  Model.swift
//  APIPersistence
//
//  Created by Alley Pereira on 19/03/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
	let resultCount: Int
	let results: [ResultModel]
}

// MARK: - Result
struct ResultModel: Codable {
	let wrapperType: WrapperType
	let kind: Kind
	let artistID, collectionID, trackID: Int
	let artistName: String
	let collectionName, trackName, collectionCensoredName, trackCensoredName: String
	let artistViewURL, collectionViewURL, trackViewURL: String
	let previewURL: String
	let artworkUrl100: String
	let collectionPrice, trackPrice: Double
	let releaseDate: String
	let collectionExplicitness, trackExplicitness: Explicitness
	let discCount, discNumber, trackCount, trackNumber: Int
	let trackTimeMillis: Int
	let country: Country
	let currency: Currency
	let primaryGenreName: PrimaryGenreName
	let contentAdvisoryRating: ContentAdvisoryRating
	let isStreamable: Bool
	let collectionArtistID: Int?
	let collectionArtistName: String?

	enum CodingKeys: String, CodingKey {
		case wrapperType, kind
		case artistID = "artistId"
		case collectionID = "collectionId"
		case trackID = "trackId"
		case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
		case artistViewURL = "artistViewUrl"
		case collectionViewURL = "collectionViewUrl"
		case trackViewURL = "trackViewUrl"
		case previewURL = "previewUrl"
		case artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, isStreamable
		case collectionArtistID = "collectionArtistId"
		case collectionArtistName
	}
}

enum Explicitness: String, Codable {
	case cleaned = "cleaned"
	case explicit = "explicit"
}

enum ContentAdvisoryRating: String, Codable {
	case clean = "Clean"
	case explicit = "Explicit"
}

enum Country: String, Codable {
	case usa = "USA"
}

enum Currency: String, Codable {
	case usd = "USD"
}

enum Kind: String, Codable {
	case song = "song"
}

enum PrimaryGenreName: String, Codable {
	case hipHopRap = "Hip-Hop/Rap"
	case soundtrack = "Soundtrack"
}

enum WrapperType: String, Codable {
	case track = "track"
}
