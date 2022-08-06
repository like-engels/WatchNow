//
//  ViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class rootTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
       // NOTE: Uncoment the line below just for testing purposes
       // view.backgroundColor = .systemYellow
        view.insetsLayoutMarginsFromSafeArea = true
        
        // all navigationbar items
        let homeVC = UINavigationController(rootViewController: HomepageViewController())
        let discoverVC = UINavigationController(rootViewController: DiscoverViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        // All tab items icons
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        discoverVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        // setting titles
        homeVC.title = "Home"
        discoverVC.title = "Discover"
        searchVC.title = "Search"
        downloadsVC.title = "Downloads"
        
        // colouring labels and icons
        
        setViewControllers([homeVC, discoverVC, searchVC, downloadsVC], animated: true)
    }


}

