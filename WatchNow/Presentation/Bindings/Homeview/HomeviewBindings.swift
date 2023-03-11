//
//  HomeviewBindings.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/3/23.
//

import UIKit

class HomeviewBindings: NSObject, ObservableObject {
    private let sectionTitles: [Int :String] = [
        0: "Trending Movies",
        1: "Trending TV",
        2: "Popular",
        3: "Upcoming Movies",
        4: "Top Rated"
    ]
    
}

extension HomeviewBindings: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
