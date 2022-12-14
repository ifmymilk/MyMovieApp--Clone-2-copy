//
//  TrendingMovieCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Simon LE on 23/07/2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var releaseDateLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
