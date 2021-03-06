//
//  ViewController.swift
//  MovieToYou
//
//  Created by Victor Vidal on 01/07/21.
//

import UIKit
class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieConstraints: NSLayoutConstraint!
    @IBOutlet weak var movieTableView: UITableView!
    let viewmodel = MovieDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieConstraints.constant = viewmodel.setupImageHeight(view: self.view)
        viewmodel.fetchMovieData()
        viewmodel.delegate = self
    }
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewmodel.generateTableViewCell(indexPath: indexPath, tableView: movieTableView)
    }
}

extension MovieDetailsViewController: MovieDetailViewModelDelegate {
    func didLoadMovies() {
        guard let moviePoster = self.viewmodel.movieDetail?.poster_path else {return}
        self.movieImage.image = self.viewmodel.receiveImageFromPath(path: moviePoster)
        self.movieTableView.reloadData()
    }
}

