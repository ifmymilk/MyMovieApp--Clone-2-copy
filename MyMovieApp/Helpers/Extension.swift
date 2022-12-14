//
//  Extension.swift
//  MyMovieApp
//
//  Created by Simon LE on 18/07/2022.
//

import Foundation



extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

    
