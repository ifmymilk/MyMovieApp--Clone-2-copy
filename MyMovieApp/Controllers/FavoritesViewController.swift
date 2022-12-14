//
//  DownloadViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 24/07/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    static var shared = FavoritesViewController()

    
    @IBOutlet var FavoritesTableView: UITableView!
    @IBAction func editFavorites(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut) {
            self.FavoritesTableView.isEditing = !self.FavoritesTableView.isEditing
            sender.title = (self.FavoritesTableView.isEditing) ? "Done" : "Edit"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveFavorites()
        self.FavoritesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.FavoritesTableView.reloadData()
      
    }
    
    func retrieveFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorites") {
            do {
                let decoder = JSONDecoder()
                
                let userFavorites = try decoder.decode([Movie].self, from: data)
                favorites = userFavorites
            } catch {
                print("Not able to retrieve data (\(error))")
            }
        }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorites", for: indexPath) as! FavoritesTableViewCell
        let data = favorites[indexPath.row]
        
        if let movieTitle = data.title {
            cell.movieLabel.text = movieTitle
        } else {
            cell.movieLabel.text = data.name
        }
        
        cell.moviePicture.sd_setImage(with: URL(string: data.posterURL))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favorites[indexPath.row]
        self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieView" {
            let destinationVC = segue.destination as! MovieViewController
            destinationVC.movieData = sender as? Movie
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            MovieViewController.shared.saveFavorites()
        }
    }
    
}


