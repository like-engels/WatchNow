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
    
    private let upcomingTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
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
        upcomingTable.reloadData()
        
        view.addSubview(upcomingTable)
    }
    
    convenience init(movies: [Movie]) {
        self.init()
        self.movies = movies

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieElement(movieName: movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle ?? "", posterURL: movies[indexPath.row].posterPath ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].mediaType ?? ""))
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
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
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Discover movies"
    }
    
    internal func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x - 20, y: header.bounds.origin.y, width: 100, height: 100)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
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
