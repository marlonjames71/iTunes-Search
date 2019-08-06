//
//  SearchResultController.swift
//  iTunesSearch
//
//  Created by Marlon Raskin on 8/6/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation


class SearchResultController {

	let baseURL = URL(string: "https://itunes.apple.com/search")!

	var searchResults: [SearchResult] = []

	func performSearch(searchTerm: String, resultType: ResultType, completion: @escaping(Error?) -> Void) {

		var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

		let searchTermQueryItem = URLQueryItem(name: "term", value: searchTerm)
		let entityQueryItem = URLQueryItem(name: "entity", value: resultType.rawValue)

		urlComponents?.queryItems = [searchTermQueryItem, entityQueryItem]

		guard let requestURL = urlComponents?.url else {
			NSLog("Request URL is nil")
			completion(nil)
			return
		}

		var request = URLRequest(url: requestURL)
		request.httpMethod = HTTPMethod.get.rawValue

		URLSession.shared.dataTask(with: request) { (data, _, error) in
			if let error = error {
				print("Error fetching data \(error)")
				completion(error)
				return
			}

			guard let data = data else {
				completion(NSError())
				return
			}

			let jsonDecoder = JSONDecoder()
			do {
				let searchResults = try jsonDecoder.decode(SearchResults.self, from: data)
				self.searchResults = searchResults.results
				completion(nil)
			} catch {
				completion(error)
			}
		}.resume()
	}

	enum HTTPMethod: String {
		case get = "GET"
		case put = "PUT"
		case post = "POST"
		case delet = "DELETE"
	}
}
