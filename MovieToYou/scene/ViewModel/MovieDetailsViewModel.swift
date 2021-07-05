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
    private let movieId = "122"
    func fetchMovieData(){
        receiveSimilarMoveData()
        receiveDetailMoveData()
    }
    
    func setupImageHeight(view: UIView) -> CGFloat {
        return view.frame.height * 0.45
    }
    
    func numberInSection() -> Int{
        guard let numberOfMovies = simiarMovies?.count else {return 1}
        return numberOfMovies + 1
    }
    
    func generateTableViewCell(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell{
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetail") as? MovieDetailTableViewCell else {return UITableViewCell()}
            guard let views = movieDetail?.popularity else {return UITableViewCell()}
            guard let likes = movieDetail?.vote_count else {return UITableViewCell()}
            cell.movieName.text = movieDetail?.original_title
            cell.movieViews.text = String(format: "%.0f", views)
            cell.moviewLikes.text = String(likes)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarMoviesCell") as? SimilarMovieTableViewCell else {return UITableViewCell()}
            cell.movieName.text = simiarMovies?[indexPath.row - 1].original_title
            cell.movieDataRelease.text = simiarMovies?[indexPath.row - 1].release_date
            guard let moviePoster = simiarMovies?[indexPath.row - 1].poster_path else {return UITableViewCell()}
            cell.moviePoster.image = receiveImageFromPath(path: moviePoster)
            return cell
        }
        
    }
    
    private func receiveDetailMoveData(){
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
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
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
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
    
    func receiveImageFromPath(path: String)-> UIImage {
        guard let url = URL(string: "https://www.themoviedb.org/t/p/w1280\(path)") else {return UIImage()}
            if let data = try? Data(contentsOf: url) {
                guard let moviePoster = UIImage(data: data) else {return UIImage()}
                return moviePoster
            }
        return UIImage()
    }
}
