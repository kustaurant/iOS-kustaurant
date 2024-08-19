//
//  HomeViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/16/24.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    private var viewModel: HomeViewModel
    private var homeLayoutTableViewHandler: HomeLayoutTableViewHandler?
    private var homeView = HomeView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        homeLayoutTableViewHandler = HomeLayoutTableViewHandler(
            view: homeView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        setupNavigationBar()
        viewModel.fetchRestaurantLists()
    }
}

extension HomeViewController {
    private func setupNavigationBar() {
        let image = UIImage(named: "logo_home")?.resized(to: CGSize(width: 126, height: 33))
        let logoImageView = UIImageView(image: image)
        let button = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = button
    }
}

// MARK: - Bindings
extension HomeViewController {
    private func setupBindings() {
        bindMainSection()
        bindSection(publisher: viewModel.bannersPublisher, section: .banner, atIndex: 0)
        bindSection(publisher: viewModel.topRestaurantsPublisher, section: .topRestaurants)
        bindSection(publisher: viewModel.forMeRestaurantsPublisher, section: .forMeRestaurants)
    }
    
    private func bindMainSection() {
        viewModel.mainSectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.homeLayoutTableViewHandler?.reloadTable()
            }.store(in: &cancellables)
    }
    
    private func bindSection<T>(
        publisher: Published<T>.Publisher,
        section: HomeSection,
        atIndex index: Int? = nil
    ) where T: Collection {
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                guard !data.isEmpty else {
                    self.viewModel.mainSections.removeAll(where: { $0 == section })
                    return
                }
                
                if !(self.viewModel.mainSections.contains(where: { $0 == section })) {
                    if let index = index {
                        self.viewModel.mainSections.insert(section, at: index)
                    } else {
                        self.viewModel.mainSections.append(section)
                    }
                } else {
                    self.homeLayoutTableViewHandler?.reloadSection(section)
                }
            }
            .store(in: &cancellables)
    }
}
