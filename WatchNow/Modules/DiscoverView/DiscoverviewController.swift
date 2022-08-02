//
//  UpcomingViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class DiscoverviewController: UIViewController {
    
    private var movies = [Movie]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(DiscoverTabTableViewCell.self, forCellReuseIdentifier: DiscoverTabTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self

        fetchUpcoming()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension DiscoverviewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTabTableViewCell.identifier, for: indexPath) as? DiscoverTabTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieViewModel(movieName: movies[indexPath.row].original_name ?? movies[indexPath.row].original_title ?? "", posterURL: movies[indexPath.row].poster_path ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].media_type ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let movieName = movie.original_name ?? movie.original_title else { return }
        
        APICaller.shared.getMovie(with: movieName) { result in
            switch result {
            case .success(let movieResult):
                DispatchQueue.main.async { [weak self] in
                    let vc = MoviePreviewViewController()
                    let viewModel = MovieVideoViewModel(title: movieName, overview: movie.overview ?? "", youtubeVideo: movieResult)
                    vc.configure(with: viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
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
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    self?.downloadMovieAt(indexPath: indexPath)
                }
                return UIMenu(title: "", subtitle: nil, image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
}

extension DiscoverviewController {
    private func downloadMovieAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadMovieWith(model: movies[indexPath.row]) { result in
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
