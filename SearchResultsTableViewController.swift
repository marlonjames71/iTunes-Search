//
//  SearchResultsTableViewController.swift
//  iTunesSearch
//
//  Created by Marlon Raskin on 8/6/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

	let searchResultsController = SearchResultController()

	@IBOutlet weak var segControl: UISegmentedControl!
	@IBOutlet weak var searchBar: UISearchBar!


	override func viewDidLoad() {
        super.viewDidLoad()
		searchBar.delegate = self
		searchBar.placeholder = "Search Apps..."
		tableView.tableFooterView = UIView()

    }

	@IBAction func segControlChanged(_ sender: UISegmentedControl) {
		switch segControl.selectedSegmentIndex {
		case 0:
			searchBar.placeholder = "Search Apps..."
			segControlSearch()
		case 1:
			searchBar.placeholder = "Search Music..."
			segControlSearch()
		case 2:
			searchBar.placeholder = "Search Movies..."
			segControlSearch()
		default:
			break
		}
	}

	func segControlSearch() {
		if searchBar.text != "" {
			searchBarSearchButtonClicked(searchBar)
		}
	}

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let results = searchResultsController.searchResults
        return results.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
		let result = searchResultsController.searchResults[indexPath.row]
		cell.textLabel?.text = result.title
		cell.detailTextLabel?.text = result.creator

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension SearchResultsTableViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchInput = searchBar.text else { return }
		var resultType: ResultType!
		switch segControl.selectedSegmentIndex {
		case 0:
			resultType = .software
		case 1:
			resultType = .musicTrack
		case 2:
			resultType = .movie
		default:
			break
		}
		searchResultsController.performSearch(searchTerm: searchInput, resultType: resultType) { (error) in
			if let error = error {
				print("Error fetching data: \(error)")
				return
			}
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
		searchBar.endEditing(true)
	}
}
