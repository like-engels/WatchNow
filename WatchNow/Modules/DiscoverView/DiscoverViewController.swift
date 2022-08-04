//
//  UpcomingViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit
import Combine

class DiscoverViewController: UIViewController {
    
    private var movies = [Movie]()
    private var cancellables = Set<AnyCancellable>()
    private let service = TheMovieDBNetworkAPIManagerImplementation.shared
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(DiscoverTabTableViewCell.self, forCellReuseIdentifier: DiscoverTabTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.insetsLayoutMarginsFromSafeArea = true

        upcomingTable.delegate = self
        upcomingTable.dataSource = self

        fetchUpcoming()
        
        view.addSubview(upcomingTable)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        lazy var cancellable = self.service
            .request(from: .getDiscoverFeed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (res) in
                switch (res) {
                case .finished:
                    self?.upcomingTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] res in
                self?.movies = res.movies
            }
        self.cancellables.insert(cancellable)
    }
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTabTableViewCell.identifier, for: indexPath) as? DiscoverTabTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieElement(movieName: movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle ?? "", posterURL: movies[indexPath.row].posterPath ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].mediaType ?? ""))
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
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

extension DiscoverViewController {
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
