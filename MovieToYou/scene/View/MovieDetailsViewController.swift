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
    let viewmodel = MovieDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieConstraints.constant = viewmodel.setupImageHeight(view: self.view)
    }
}

