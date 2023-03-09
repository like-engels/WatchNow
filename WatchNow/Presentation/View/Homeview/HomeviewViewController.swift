//
//  HomeviewViewController.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/3/23.
//

import UIKit

class HomeviewViewController: UIViewController {
    
    private let sectiontitles: [Int :String] = [
        0: "Trending Movies",
        1: "Trending TV",
        2: "Popular",
        3: "Upcoming Movies",
        4: "Top Rated"
    ]
    
    let bindings: HomeviewBindings

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    init(bindings: HomeviewBindings, coder: NSCoder) {
        self.bindings = bindings
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
