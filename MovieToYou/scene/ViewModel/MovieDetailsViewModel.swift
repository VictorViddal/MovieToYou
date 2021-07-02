//
//  MovieDetailsViewModel.swift
//  MovieToYou
//
//  Created by Victor Vidal on 02/07/21.
//

import UIKit

class MovieDetailViewModel {
    var movieDetail: MovieDetails?
    var simiarMovies: [Results]?
    
    func fetchMovieData(){
        receiveSimilarMoveData()
        receiveDetailMoveData()
    }
    
    func setupImageHeight(view: UIView) -> CGFloat {
        return view.frame.height * 0.45
    }
    
    private func receiveDetailMoveData(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/122?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                    DispatchQueue.main.async {
                        self?.movieDetail = decodedResponse
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    private func receiveSimilarMoveData(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/122/similar?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(SimilarMovies.self, from: data) {
                    DispatchQueue.main.async {
                        self?.simiarMovies = decodedResponse.results
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}
