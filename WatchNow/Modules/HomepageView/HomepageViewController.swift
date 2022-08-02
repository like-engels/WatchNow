//
//  HomeViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomepageViewController: UIViewController {
    
    private var randomSelectedBanner: Movie?
    private var headerView: HeroHeaderView?
    
    let sectionTitles: [String] = [
        "Trending Movies",
        "Popular",
        "Trending TV",
        "Top rated",
        "Upcoming Movies"
    ]

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Homepage"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.insetsLayoutMarginsFromSafeArea = true
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        configureHeroHeader()
        homeFeedTable.tableHeaderView = headerView
        
        view.addSubview(homeFeedTable)
        
    }
    
    private func configureHeroHeader() {
        APIManager.shared.getTrendingMovies { movie in
            switch movie {
            case .success(let movie):
                self.randomSelectedBanner = movie.randomElement()
                guard let selectedBanner = self.randomSelectedBanner else { return }
                self.headerView?.configure(with: selectedBanner)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureNavbar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
        
    }
}

extension HomepageViewController: UITableViewDelegate, UITableViewDataSource {
    internal func numberOfSections(in tableView: UITableView) -> Int {
        sectionTitles.count
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APIManager.shared.getTrendingMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TrendingTV.rawValue:
            APIManager.shared.getTrendingSeries { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APIManager.shared.getPopularMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APIManager.shared.getUpcomingMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APIManager.shared.getTopRatedMovies { results in
                switch results {
                case .success(let movies):
                    cell.configure(with: movies)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    internal func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    internal func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x - 20, y: header.bounds.origin.y, width: 100, height: 100)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
}

extension HomepageViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: MovieVideoViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
