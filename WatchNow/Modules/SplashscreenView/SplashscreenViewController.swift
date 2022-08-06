//
//  LoadingScreenViewController.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 4/8/22.
//

import UIKit

class SplashscreenViewController: UIViewController {
    
    private let label: UILabel = {
        var label = UILabel()
        label.text = "Loading movies, getting all things done..."
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let splashColor: UIColor = UIColor.init(hex: "#2E3440")!
    
    private let splashLogo: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "SplashscreenLogo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = splashColor
        view.addSubview(splashLogo)
        view.addSubview(label)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyConstraints()
    }
    
//    convenience init() {
//        self.init(nibName:nil, bundle:nil)
//
//    }
    
//    override init(nibName: String?, bundle: Bundle?) {
//        super.init(nibName: nibName, bundle: bundle)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            splashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashLogo.widthAnchor.constraint(lessThanOrEqualToConstant: 512),
            splashLogo.heightAnchor.constraint(lessThanOrEqualToConstant: 512),
        ])
    }



}
