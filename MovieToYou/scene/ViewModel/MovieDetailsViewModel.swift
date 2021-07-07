//
//  MovieDetailsViewModel.swift
//  MovieToYou
//
//  Created by Victor Vidal on 02/07/21.
//

import UIKit
protocol MovieDetailViewModelDelegate: AnyObject{
    // delegate to load TableView when fetch movies Data
    func didLoadMovies()
}
class MovieDetailViewModel {
    var movieDetail: MovieDetails?
    var simiarMovies: [Results]?
    weak var delegate: MovieDetailViewModelDelegate?
    private let movieId = "122"
    var posterImages: [UIImage] = []
    
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
            cell.movieDataRelease.text = similarMovieInformation(release: simiarMovies?[indexPath.row - 1].release_date, genresIds: simiarMovies?[indexPath.row - 1].genre_ids)
            cell.moviePoster.image = posterImages[indexPath.row - 1]
            return cell
        }
        
    }
    
    // Make APIRequest from movie details URL
    private func receiveDetailMoveData(){

        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(MovieDetails.self, from: data) {
                    DispatchQueue.main.async {
                        self?.movieDetail = decodedResponse
                        self?.delegate?.didLoadMovies()
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    // Make APIRequest from similarMovies URL
    private func receiveSimilarMoveData(){

        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=7c04bfa24c6cdf62a15ef9edcd3f3065") else{ fatalError("couldn't connect with url")}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(SimilarMovies.self, from: data) {
                    DispatchQueue.main.async {
                        self?.simiarMovies = decodedResponse.results
                        self?.allSimilarMoviePost(similarMoviesList: self?.simiarMovies)
                    }
                    return
                }
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    // Make Requst from image by poster_path
    func receiveImageFromPath(path: String)-> UIImage {

        guard let url = URL(string: "https://www.themoviedb.org/t/p/w1280\(path)") else {return UIImage()}
            if let data = try? Data(contentsOf: url) {
                guard let moviePoster = UIImage(data: data) else {return UIImage()}
                return moviePoster
            }
        return UIImage()
    }
    
    // Save all poster image in local var to faster access
    private func allSimilarMoviePost(similarMoviesList: [Results]?)  {

        guard let moviesImage = similarMoviesList else {return}
        for poster in moviesImage{
            guard let moviePoster = poster.poster_path else {return}
            posterImages.append(receiveImageFromPath(path: moviePoster))
        }
    }
    
    // tranform relase and genre Ids in format "ReleasaYar <genres1, genre2, ...>"
    private func similarMovieInformation(release: String?,genresIds:[Int]?) -> String{
        
        guard let releaseDate = release?.prefix(4) else {return String()}
        guard let genres = genresIds else {return String()}
        var movieGenreArray: [String] = []
        for type in genres {
            guard let movieGenre = movieGenres[type] else{return ""}
            movieGenreArray.append(movieGenre)
        }
        let movieInformation = releaseDate + "  " + movieGenreArray.joined(separator: ", ")
        return movieInformation
    }
}

