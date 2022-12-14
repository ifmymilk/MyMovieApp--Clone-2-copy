//
//  FavoritesTableViewCell.swift
//  MyMovieApp
//
//  Created by Simon LE on 12/10/2022.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    
    @IBOutlet var moviePicture: UIImageView!
    @IBOutlet var movieLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

