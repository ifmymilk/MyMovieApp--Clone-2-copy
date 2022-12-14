//
//  trailerTableViewCell.swift
//  MyMovieApp
//
//  Created by Simon LE on 21/08/2022.
//

import UIKit
import YouTubeiOSPlayerHelper

class trailerTableViewCell: UITableViewCell {
    
    
    @IBOutlet var videoLink: YTPlayerView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
