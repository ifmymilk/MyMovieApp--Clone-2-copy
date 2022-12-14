//
//  TMDBCall.swift
//  MyMovieApp
//
//  Created by Simon LE on 15/07/2022.
//

import Foundation


class FetchData {
    static let key = "0f98062d2ab21b8e017ade737f9912ed"
    static let shared = FetchData()
    
    
    func getTrendingMovie(completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTv(completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/tv/week?api_key=\(FetchData.key)&language=fr-fr&region=fr&with_release_type=2") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
            
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    //
    
    func getUpcomingMovie(completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=1") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    
    func nowPlayingMovie(completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(FetchData.key)&language=fr-fr&region=FR&page=5") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    
    func getTrailer(id movieID: Int, completion: @escaping (Result<Identification, Error>) -> Void) {
        
        guard let urlMovie = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else { return }
        
            let task = URLSession.shared.dataTask(with: urlMovie) { data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                do {
                    let results = try JSONDecoder().decode(Identification.self, from: data)
                    completion(.success(results))
                    
                } catch {
                    completion(.failure(error))
                    print(String(describing: error))
                }
            }
            task.resume()
        }
    
    
    func getTvTrailer(id movieID: Int, completion: @escaping (Result<Identification, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(movieID)/videos?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else
        { return }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Identification.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        task.resume()
    }
    
    
    func getMovieCredit(id movieID: Int, completion: @escaping (Result<MovieCredit, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MovieCredit.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    func getTvCredit(id movieID: Int, completion: @escaping (Result<MovieCredit, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.themoviedb.org/3/tv/\(movieID)/credits?api_key=\(FetchData.key)&language=fr-fr&region=FR&with_release_type=2") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(MovieCredit.self, from: data)
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print(String(describing: error))
            }
        }
        
        task.resume()
    }
    
    func movieSearch(with query: String, completion: @escaping (Result<Movies, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(FetchData.key)&query=\(query)") else
        { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Movies.self, from: data)
                completion(.success(results))
              
                
                
            } catch {
                completion(.failure(error))
                print(error)
            }
        }
        task.resume()
    } 
}
