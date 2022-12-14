//
//  UpcomingViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 24/07/2022.
//

import UIKit


class UpcomingViewController: UIViewController {
    
    @IBOutlet var upcomingColllectionView: UICollectionView!
    
    private var upcomingMovie: [Movie] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FetchData().getUpcomingMovie { results in
            switch results {
            case .success(let movie):
                self.upcomingMovie = movie.results.sorted {
                    $0.release_date! < $1.release_date!
                }
                DispatchQueue.main.async {
                    self.upcomingColllectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension UpcomingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return upcomingMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let data = upcomingMovie[indexPath.item]
        cell.releaseDateLabel.text = data.release_date
        cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMovie = upcomingMovie[indexPath.item]
        self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieView" {
            let destinationVC = segue.destination as! MovieViewController
            destinationVC.movieData = sender as? Movie
            
           
        }
    }
}
