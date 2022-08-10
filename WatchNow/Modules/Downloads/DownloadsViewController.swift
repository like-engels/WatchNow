//
//  DownloadsViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private let downloadsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    private var movies = [MovieItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(downloadsTable)
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.insetsLayoutMarginsFromSafeArea = true
        
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        downloadsTable.reloadData()
        
     //   fetchLocalStorageForDownload()
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
//            self.fetchLocalStorageForDownload()
//        }
    }
    
    convenience init(movies: [MovieItem]) {
        self.init()
        self.movies = movies
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieElement(movieName: movies[indexPath.row].originalName ?? movies[indexPath.row].originalTitle ?? "", posterURL: movies[indexPath.row].posterPath ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].media_type ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMovieFromCoreData(movie: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from Database")
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                if (self?.movies.count)! > 1 {
                    self?.movies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self?.movies.remove(at: indexPath.row)
                }
                
            }
        default: break;
        }
    }
}
