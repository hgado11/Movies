//
//  BaseCollectionViewController.swift
//  Movies
//
//  Created by Hassan Gado on 9/13/19.
//  Copyright © 2019 Hassan Gadou. All rights reserved.
//

import UIKit



class BaseCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,AlertDisplayer {
    let reuseIdentifier = "collectionCell"
    let  indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 50, y: 50, width: 20, height: 20))
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width/2
        let height = width + 50
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    
    
}
