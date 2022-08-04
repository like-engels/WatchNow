//
//  UpcomingTabTableViewCell.swift
//  WatchNow
//
//  Created by User-D on 7/21/22.
//

import UIKit
import SDWebImage

class DiscoverTabTableViewCell: UITableViewCell {

    static let identifier = "DiscoverTabTableViewCell"
    
    private lazy var moviePlayButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var movieLabel: UILabel = {
        let text = UILabel()
        text.numberOfLines = .zero
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var moviePosterImageView: UIImageView = {
        let image = UIImageView ()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(moviePosterImageView)
        contentView.addSubview(movieLabel)
        contentView.addSubview(moviePlayButton)
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        
        NSLayoutConstraint.activate([
            moviePlayButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moviePlayButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            moviePlayButton.widthAnchor.constraint(equalToConstant: 48)
        ])
        NSLayoutConstraint.activate([
            movieLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieLabel.trailingAnchor.constraint(equalTo: moviePlayButton.leadingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            moviePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    public func configure(with movie: MovieElement) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterURL)") else { return }
        
        moviePosterImageView.sd_setImage(with: url)
        movieLabel.text = movie.movieName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
