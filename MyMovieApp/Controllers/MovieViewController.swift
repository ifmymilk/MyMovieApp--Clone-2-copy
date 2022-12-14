//
//  MovieViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 06/08/2022.
//

import UIKit
import YouTubeiOSPlayerHelper
import AVFoundation
import AVKit



class MovieViewController: UIViewController {
    
    
    @IBOutlet var movieDetailImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var overviewLabel: UITextView!
    @IBOutlet var trailerTableView: UITableView!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var releaseLabel: UILabel!
    @IBOutlet var castList: UITextView!
    @IBOutlet var crewList: UITextView!

    
    var cast = [MovieCast]()
    var crew = [MovieCrew]()
    var movieData: Movie?
    var movieName: String?
    var overview: String?
    var trailer = [Infos]()
    var movieList = [Movie]()
    static let shared = MovieViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trailerTableView.delegate = self
        self.trailerTableView.dataSource = self
        fetchAll()
        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    func fetchAll() {
        if movieData?.media_type != "tv" {
            FetchData.shared.getTrailer(id: (movieData?.id)!) { results in
                switch results {
                case .success(let result):
                    self.trailer = result.results
                    DispatchQueue.main.async {
                        self.trailerTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            FetchData.shared.getTvTrailer(id: (movieData?.id)!) { results in
                switch results {
                case .success(let result):
                    self.trailer = result.results
                    DispatchQueue.main.async {
                        self.trailerTableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        if movieData?.media_type == "tv" {
            FetchData.shared.getTvCredit(id: (movieData?.id)!) { results in
                switch results {
                case .success(let result):
                    self.cast = result.cast
                    self.crew = result.crew
                    DispatchQueue.main.async {
                        self.updateView()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            FetchData.shared.getMovieCredit(id: (movieData?.id)!) { results in
                switch results {
                case .success(let result):
                    self.cast = result.cast
                    self.crew = result.crew
                    DispatchQueue.main.async {
                        self.updateView()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func addTapped() {
        if favorites.contains(where:  {$0.id == movieData?.id })  {
            navigationItem.rightBarButtonItem?.title = "Already in your list"
        } else {
            favorites.append(movieData!)
            navigationItem.rightBarButtonItem?.title = "Added to your list"
            saveFavorites()
        }
    }
    
    func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(favorites)
            UserDefaults.standard.set(data, forKey: "favorites")
        } catch {
            print("Unable to encode Array of favorites (\(error))")
        }
    }
    
    func updateView() {
        
        self.overview = self.movieData?.overview
        self.overviewLabel.text = self.overview
        
        if let movieTitle = self.movieData?.title {
            self.movieName = movieTitle
        } else {
            self.movieName = self.movieData?.name
        }
        
        if let number = self.movieData?.vote_average, self.movieData?.vote_average != 0.0 {
            self.ratingLabel.text = "Rating: " + String(format: "%.1f", number)
        } else {
            self.ratingLabel.text = "Rating: NA"
        }
        
        self.releaseLabel.text = "Release: " + (self.movieData?.release_date ?? "")
        self.movieTitle.text = self.movieName
        
        let backImage = self.movieData?.backdropURL
        let secondeImage = self.movieData?.posterURL
        if backImage == "https://image.tmdb.org/t/p/w500" {
            self.movieDetailImage.sd_setImage(with: URL(string: (secondeImage!)))
        } else {
            self.movieDetailImage.sd_setImage(with: URL(string: (backImage!)))
        }
        
        let filterCast = self.cast.prefix(20)
        let arrayCast = filterCast.map {$0.name}.joined(separator: "\n")
        self.castList.text = arrayCast
        
        let filterCrew = self.crew.prefix(15)
        let arrayCrew = filterCrew.flatMap({[$0.job, $0.name.uppercased()] }).joined(separator: "\n")
        self.crewList.text = arrayCrew
    }
}


extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trailer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoLink", for: indexPath) as! trailerTableViewCell
        let id = trailer[indexPath.item]
        guard let movieId = id.key else { return cell }
        cell.videoLink.load(withVideoId: movieId)
        return cell
    }
}


