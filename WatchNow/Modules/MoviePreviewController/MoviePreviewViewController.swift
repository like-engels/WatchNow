//
//  MoviePreviewViewController.swift
//  WatchNow
//
//  Created by Higashikata Maverick on 24/7/22.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController {
    private var webView: WKWebView = {
        var webview = WKWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()

    private var movieLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = .zero
        return label
    }()
    
    private var overviewLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = .zero
        return label
    }()
    
    private var downloadButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.insetsLayoutMarginsFromSafeArea = true
        
        view.addSubview(webView)
        view.addSubview(movieLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
        configureConstraints()
    }
    
    
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            webView.heightAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])

        NSLayoutConstraint.activate([movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 10),
            movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([overviewLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        NSLayoutConstraint.activate([downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }
    
    func configure(with model: ThinYoutubeTrailer) {
        movieLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeVideo.id.videoId)") else { return }
        
        webView.load(URLRequest(url: url))
    }

}
