//
//  SearchResult.swift
//  iTunesSearch
//
//  Created by Marlon Raskin on 8/6/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


struct SearchResult: Codable {
	let title: String
	let creator: String

	enum CodingKeys: String, CodingKey {
		case title = "trackName"
		case creator = "artistName"
	}
}

struct SearchResults: Codable {
	let results: [SearchResult]
}
