//
//  SearchResultsViewController.swift
//  WatchNow
//
//  Created by User-D on 7/22/22.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    public let filteredResultsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 4
        collectionViewLayout.itemSize = CGSize(width: 100, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
        
    }()
    
    public var moviesQuery = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        filteredResultsCollectionView.delegate = self
        filteredResultsCollectionView.dataSource = self
        
        view.addSubview(filteredResultsCollectionView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        filteredResultsCollectionView.frame = view.bounds
        filteredResultsCollectionView.contentMode = .scaleAspectFit
    }
    
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesQuery.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        let title = moviesQuery[indexPath.row]
        cell.configurate(with: title.poster_path ?? "")
        cell.contentMode = .scaleAspectFit
        cell.insetsLayoutMarginsFromSafeArea = true
        cell.clipsToBounds = true
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", state: .off) { [weak self] _ in
                    self?.downloadMovieAt(indexPath: indexPath)
                }
                return UIMenu(title: "Movie Options", options: .displayInline, children: [downloadAction])
            }
        return config
    }
}

extension SearchResultsViewController {
    private func downloadMovieAt(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadMovieWith(movie: moviesQuery[indexPath.row]) { result in
            switch result {
            case .success(()):
                print("Downloaded to Database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print("Downloading... \(moviesQuery[indexPath.row].original_title ?? moviesQuery[indexPath.row].original_name ?? "")")
    }
}
