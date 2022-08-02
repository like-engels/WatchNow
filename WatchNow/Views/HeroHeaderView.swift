//
//  HeroHeaderUIView.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class HeroHeaderView: UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func applyConstraints() {
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 50),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -50),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    func configure(with model: Movie) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.poster_path ?? "")") else { return }
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
