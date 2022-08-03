//
//  HomeViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit
import Combine

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomepageViewController: UIViewController {
    
    private let sectionTitles = [
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

    private var randomSelectedBanner: Movie?
    private var headerView: HeroHeaderView?
    private var cancellables = Set<AnyCancellable>()
    private var service = TheMovieDBNetworkAPIManagerImplementation.shared

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeader() {
        let cancellable = self.service
            .request(from: .getTrendingMovies)
            .sink { (res) in
            } receiveValue: { res in
                self.randomSelectedBanner = res.results.randomElement()
                guard let selectedBanner = self.randomSelectedBanner else { return }
                self.headerView?.configure(with: selectedBanner)
            }
        self.cancellables.insert(cancellable)
    }
    
    private func configureNavbar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .done, target: self, action: nil)
        ]
        
        // navigationController?.navigationBar.tintColor = .label
        
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
        var test: EndpointImplementation
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            test = .getTrendingMovies
            configureCell()

        case Sections.TrendingTV.rawValue:
            test = .getTrendingSeries
            configureCell()

        case Sections.Popular.rawValue:
            test = .getPopularMovies
            configureCell()

        case Sections.Upcoming.rawValue:
            lazy var cancellable = self.service
                .request(from: .getUpcomingMovies)
                .receive(on: DispatchQueue.main)
                .sink { (res) in
                } receiveValue: { res in
                    cell.configure(with: res.results)
                }
            self.cancellables.insert(cancellable)

        case Sections.TopRated.rawValue:
            lazy var cancellable = self.service
                .request(from: .getTopRatedMovies)
                .receive(on: DispatchQueue.main)
                .sink { (res) in
                } receiveValue: { res in
                    cell.configure(with: res.results)
                }
            self.cancellables.insert(cancellable)

        default:
            return UITableViewCell()
        }
        
        func configureCell() {
            lazy var cancellable = self.service
                .request(from: test)
                .receive(on: DispatchQueue.main)
                .sink { (res) in
                } receiveValue: { res in
                    cell.configure(with: res.results)
                }
            self.cancellables.insert(cancellable)
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
    func CollectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, model: ThinYoutubeTrailer) {
        DispatchQueue.main.async { [weak self] in
            let vc = MoviePreviewViewController()
            vc.configure(with: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
