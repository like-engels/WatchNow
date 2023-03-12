//
//  TabBarViewController.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 11/3/23.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let homeView = HomeviewViewController(bindings: HomeviewBindings())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setUI()

    }
    
    func setUI() {
        var controllers: [UINavigationController] = []
        
        let homeViewController = UINavigationController(rootViewController: homeView)
        homeViewController.tabBarItem = UITabBarItem(title: "Homepage", image: UIImage(systemName: "house"), tag: 0)
        
        controllers.append(homeViewController)
        
        viewControllers = controllers
    }

}
