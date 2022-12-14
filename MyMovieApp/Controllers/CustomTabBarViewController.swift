//
//  CustomTabBarViewController.swift
//  MyMovieApp
//
//  Created by Simon LE on 24/07/2022.
//

import UIKit

class CustomTabBarViewController: UITabBarController {

    public var accountSignIn: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBar.tintColor = UIColor(named: "TabBarTint")
  
        self.tabBar.layer.opacity = 0.9
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
        
        self.tabBar.selectionIndicatorImage = UIImage(named: "Selected")
//        self.additionalSafeAreaInsets.bottom = 5
        
    
    }
}

