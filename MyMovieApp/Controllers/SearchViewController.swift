//
//  SearchViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 24/07/2022.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet var searchTableView: UITableView!
    
    var movieResults = [Movie]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter Movie or Tv Show name"
        
        
        FetchData().getTopRated { results in
            switch results {
            case .success(let result):
                DispatchQueue.main.async {
                    self.movieResults = result.results
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search", for: indexPath) as! SearchTableViewCell
        let data = movieResults[indexPath.item]
        cell.searchResultLabel.text = data.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movieResults[indexPath.row]
        self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieView" {
            let destinationVC = segue.destination as! MovieViewController
            destinationVC.movieData = sender as? Movie
        }
    }
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        
        FetchData.shared.movieSearch(with: query) { results in
            switch results {
            case .success(let result):
                DispatchQueue.main.async {
                    self.movieResults = result.results
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

