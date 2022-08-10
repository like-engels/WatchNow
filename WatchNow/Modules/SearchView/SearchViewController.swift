//
//  SearchViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let discoverTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search movies or TV show..."
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
    
    private var movies = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        view.insetsLayoutMarginsFromSafeArea = true

        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        discoverTableView.reloadData()
        searchController.searchResultsUpdater = self

        view.addSubview(discoverTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    convenience init(movies: [Movie]) {
        self.init()
        self.movies = movies
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieElement(movieName: movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle ?? "", posterURL: movies[indexPath.row].posterPath ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].mediaType ?? ""))
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.originalName ?? movie.originalTitle else { return }
        
        APIManager.shared.getMovie(with: movieName) { result in
            switch result {
            case .success(let movieResult):
                DispatchQueue.main.async { [weak self] in
                    let previewViewController = MoviePreviewViewController()
                    let model = MovieTrailer(title: movieName, overview: movie.overview ?? "", youtubeVideo: movieResult)
                    previewViewController.configure(with: model)
                    self?.navigationController?.pushViewController(previewViewController, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Popular movies"
    }
    
    internal func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x - 20, y: header.bounds.origin.y, width: 100, height: 100)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }

}

extension SearchViewController: UISearchResultsUpdating {
    
    internal func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3, let resultController = searchController.searchResultsController as? SearchResultsViewController else { return }
        
        APIManager.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let queries):
                    resultController.moviesQuery = queries
                    resultController.filteredResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
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

extension SearchViewController {
    private func downloadMovieAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadMovieWith(movie: movies[indexPath.row]) { result in
            switch result {
            case .success(()):
                print("Downloaded to Database")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        print("Downloading... \(movies[indexPath.row].originalTitle ?? movies[indexPath.row].originalName ?? "")")
    }
}
