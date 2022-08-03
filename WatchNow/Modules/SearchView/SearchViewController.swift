//
//  SearchViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let discoverTableView: UITableView = {
        let table = UITableView()
        table.register(DiscoverTabTableViewCell.self, forCellReuseIdentifier: DiscoverTabTableViewCell.identifier)
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
    private var cancellables = Set<AnyCancellable>()
    private var service = TheMovieDBNetworkAPIManagerImplementation.shared

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
        searchController.searchResultsUpdater = self

        fetchDiscoverMovies()

        view.addSubview(discoverTableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        lazy var cancellable = self.service
            .request(from: .getTopRatedMovies)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (res) in
                switch (res) {
                case .finished:
                    self?.discoverTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] res in
                self?.movies = res.results
            }
        self.cancellables.insert(cancellable)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTabTableViewCell.identifier, for: indexPath) as? DiscoverTabTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: ThinMovie(movieName: movies[indexPath.row].original_name ?? movies[indexPath.row].original_title ?? "", posterURL: movies[indexPath.row].poster_path ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].media_type ?? ""))
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_name ?? movie.original_title else { return }
        
        APIManager.shared.getMovie(with: movieName) { result in
            switch result {
            case .success(let movieResult):
                DispatchQueue.main.async { [weak self] in
                    let vc = MoviePreviewViewController()
                    let model = ThinYoutubeTrailer(title: movieName, overview: movie.overview ?? "", youtubeVideo: movieResult)
                    vc.configure(with: model)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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

        print("Downloading... \(movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? "")")
    }
}
