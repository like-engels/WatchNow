//
//  MovieCollectionViewCell.swift
//  WatchNow
//
//  Created by User-D on 7/21/22.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
        
    private lazy var movieCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(movieCover)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieCover.frame = contentView.bounds
    }
    
    public func configurate(with url: String) {

        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(url)") else { return }
        movieCover.sd_setImage(with: url, completed: nil)
        
    }
    
}
