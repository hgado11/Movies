//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController,AlertDisplayer {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var movie:Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.loadMovieData()
        
    }
    
    private func loadMovieData(){
        if let movie = self.movie{
            if let bigImage = movie.backdropPath{
            let image = URL_STRINGS.BIG_IMAGE_PATH + bigImage
            if let url = URL(string: image){
                self.movieImage.load(url: url)
                }
                
            }
            self.titleLabel.text = movie.originalTitle
            self.descriptionLabel.text = movie.overview
        }
    }
    
    
    
}
