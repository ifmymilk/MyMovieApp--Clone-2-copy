//
//  SearchTableViewCell.swift
//  MyMovieApp
//
//  Created by Simon LE on 09/09/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet var searchResultLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
