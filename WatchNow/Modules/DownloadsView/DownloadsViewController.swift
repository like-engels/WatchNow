//
//  DownloadsViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies: [MovieItem] = [MovieItem]()
    
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(DiscoverTabTableViewCell.self, forCellReuseIdentifier: DiscoverTabTableViewCell.identifier)
        return table
    }()

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
        
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.downloadsTable.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTabTableViewCell.identifier, for: indexPath) as? DiscoverTabTableViewCell else { return UITableViewCell() }
        
        cell.configure(with: MovieViewModel(movieName: movies[indexPath.row].original_name ?? movies[indexPath.row].original_title ?? "", posterURL: movies[indexPath.row].poster_path ?? "", movieOverview: movies[indexPath.row].overview ?? "", mediaType: movies[indexPath.row].media_type ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteMovieFromDataBase(model: movies[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from Database")
                    NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                if (self?.movies.count)! > 1 {
                    self?.movies.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break;
        }
    }
}
