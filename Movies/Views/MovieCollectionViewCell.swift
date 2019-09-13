//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var posterImageView: UIImageView!
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(imageurl:String){
       let posterURL = URL_STRINGS.SMALL_IMAGE_PATH + imageurl
        if let url = URL(string: posterURL){
            self.posterImageView.load(url: url)
            
        }
        
    }
    

}
