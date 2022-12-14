//
//  HomeViewController.swift
//  Necflox clone
//
//  Created by User-D on 7/20/22.
//

import UIKit
import Combine

enum Sections: Int, CaseIterable {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

final class HomepageViewController: UIViewController {
    
    private let sectionTitles = [
        "Trending Movies",
        "Trending TV",
        "Popular",
        "Upcoming Movies",
        "Top Rated"
    ]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    private var randomSelectedBanner: Movie?
    private var sectionsContent = [Sections.RawValue: [Movie]]()
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
    
    convenience init(randomMovieForBanner: Movie, sectionContents: [Sections.RawValue: [Movie]]) {
        self.init()
        self.randomSelectedBanner = randomMovieForBanner
        self.sectionsContent = sectionContents
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeader() {
        headerView?.configure(with: randomSelectedBanner!)
    }
    
    private func configureNavbar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "arrow.down.to.line"), style: .done, target: self, action: nil)
        ]
        
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
            cell.configure(with: sectionsContent[Sections.TrendingMovies.rawValue]!)

        case Sections.TrendingTV.rawValue:
            cell.configure(with: sectionsContent[Sections.TrendingTV.rawValue]!)

        case Sections.Popular.rawValue:
            cell.configure(with: sectionsContent[Sections.Popular.rawValue]!)

        case Sections.Upcoming.rawValue:
            cell.configure(with: sectionsContent[Sections.Upcoming.rawValue]!)

        case Sections.TopRated.rawValue:
            cell.configure(with: sectionsContent[Sections.TopRated.rawValue]!)

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
    func CollectionViewTableViewDidTapCell(_ cell: CollectionViewTableViewCell, model: MovieTrailer) {
        DispatchQueue.main.async { [weak self] in
            let previewViewController = MoviePreviewViewController()
            previewViewController.configure(with: model)
            self?.navigationController?.pushViewController(previewViewController, animated: true)
        }
    }
}
