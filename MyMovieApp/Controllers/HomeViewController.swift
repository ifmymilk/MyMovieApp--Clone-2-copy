//
//  ViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 15/07/2022.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseAuth


class HomeViewController: UIViewController {
    
    
    var dataMovie = [Movie]()
    var dataTv = [Movie]()
    var dataTop = [Movie]()
    var dataUpcoming = [Movie]()
    var dataNow = [Movie]()
    var movieStar: Movie?
    var accountSignIn: String?
    
    var menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Sign Out", image: UIImage(systemName: "person"), handler: { (_) in
                self.signOut()
            }),
            UIAction(title: "Dark / Light Mode", image: UIImage(systemName: "moon"), handler: { (_) in
                self.darkMode()
            })
        ]
    }
    
    @IBOutlet var TrendingMovieCollectionView: UICollectionView!
    @IBOutlet var TrendingTvCollectionView: UICollectionView!
    @IBOutlet var NowPlayingCollectionView: UICollectionView!
    @IBOutlet var UpcomingCollectionView: UICollectionView!
    @IBOutlet var TopRatedCollectionView: UICollectionView!
    @IBOutlet var headImage: UIImageView!
    @IBOutlet var releaseDate: UILabel!
    @IBAction func tapImage(_ sender: UIButton) {
        showMovieDetail()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        fetchAll()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Account", image: UIImage(systemName: "light.panel"), primaryAction: nil, menu: menu)
        
    }
    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.modalTransitionStyle = .flipHorizontal
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func darkMode() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle: window?.overrideUserInterfaceStyle
        
        if interfaceStyle != .dark {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
    }
    
   
    func showMovieDetail() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .pageSheet
        vc.movieData = movieStar! as Movie
        self.present(vc, animated: true, completion: nil)
    }
    
    func fetchAll() {
        FetchData().getTrendingMovie { results in
            switch results {
            case .success(let result):
                self.dataMovie = result.results
                DispatchQueue.main.async {
                    self.TrendingMovieCollectionView.reloadData()
                    FavoritesViewController.shared.retrieveFavorites()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        FetchData().getTrendingTv { results in
            switch results {
            case .success(let movie):
                self.dataTv = movie.results
                DispatchQueue.main.async {
                    self.TrendingTvCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        FetchData().getUpcomingMovie { results in
            switch results {
            case .success(let result):
                self.dataUpcoming = result.results
                DispatchQueue.main.async {
                    self.UpcomingCollectionView.reloadData()
                    self.updateImage()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        FetchData().nowPlayingMovie { results in
            switch results {
            case .success(let result):
                self.dataNow = result.results
                DispatchQueue.main.async {
                    self.NowPlayingCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        FetchData().getTopRated { results in
            switch results {
            case .success(let result):
                self.dataTop = result.results
                DispatchQueue.main.async {
                    self.TopRatedCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = view!.bounds
        headImage.layer.addSublayer(gradientLayer)
    }
    
    
    func updateImage() {
        DispatchQueue.main.async{
            if let data = self.dataUpcoming.randomElement() {
                self.movieStar = data
                let date = data.release_date
                self.releaseDate.text = date
                let poster = data.posterURL
                self.headImage.sd_setImage(with: URL(string: poster)) }
            else { return }
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case TrendingTvCollectionView:
            return dataTv.count
        case NowPlayingCollectionView:
            return dataNow.count
        case UpcomingCollectionView:
            return dataUpcoming.count
        case TopRatedCollectionView:
            return dataTop.count
        default:
            return dataMovie.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        switch collectionView {
        case TrendingTvCollectionView:
            let data = dataTv[indexPath.item]
            cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
            return cell
        case NowPlayingCollectionView:
            let data = dataNow[indexPath.item]
            cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
            return cell
        case UpcomingCollectionView:
            let data = dataUpcoming[indexPath.item]
            cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
            return cell
        case TopRatedCollectionView:
            let data = dataTop[indexPath.item]
            cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
            return cell
        default:
            let data = dataMovie[indexPath.item]
            cell.moviePoster.sd_setImage(with: URL(string: data.posterURL))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch collectionView {
        case TrendingTvCollectionView:
            let selectedMovie = dataTv[indexPath.item]
            self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        case NowPlayingCollectionView:
            let selectedMovie = dataNow[indexPath.item]
            self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        case UpcomingCollectionView:
            let selectedMovie = dataUpcoming[indexPath.item]
            self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        case TopRatedCollectionView:
            let selectedMovie = dataTop[indexPath.item]
            self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        default:
            let selectedMovie = dataMovie[indexPath.item]
            self.performSegue(withIdentifier: "MovieView", sender: selectedMovie)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieView" {
            let destinationVC = segue.destination as! MovieViewController
            destinationVC.movieData = sender as? Movie
        }
    }
}
