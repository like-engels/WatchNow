//
//  HomeviewViewController.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/3/23.
//

import UIKit

class HomeviewViewController: UIViewController {
    
    let bindings: HomeviewBindings
    
    private let homeviewTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Homepage"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.insetsLayoutMarginsFromSafeArea = true
        
        homeviewTableView.delegate = bindings
        homeviewTableView.dataSource = bindings
        
        view.addSubview(homeviewTableView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeviewTableView.frame = view.bounds
    }
    
    init(bindings: HomeviewBindings) {
        self.bindings = bindings
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder: NSCoder) {
        self.init(bindings: HomeviewBindings())
    }
    
}
