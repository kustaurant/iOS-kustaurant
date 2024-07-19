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
    private var homeMainCollectionViewHandler: HomeCollectionViewHandler?
    private var homeView = HomeView()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        homeMainCollectionViewHandler = HomeCollectionViewHandler(
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        bindRestaurantLists()
    }
    
    private func bindRestaurantLists() {
        viewModel.restaurantLists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lists in
                self?.processUpdates(with: lists)
            }.store(in: &cancellables)
    }
    
    private func processUpdates(with lists: HomeRestaurantLists) {
        let sectionsToUpdate = updateModel(with: lists)
        reloadData(sectionsToUpdate: sectionsToUpdate)
    }
    
    private func updateModel(with lists: HomeRestaurantLists) -> IndexSet {
        var sectionsToUpdate = IndexSet()
        if let topRestaurants = lists.topRestaurantsByRating, !topRestaurants.isEmpty {
            viewModel.topRestaurants = topRestaurants.compactMap({ $0 })
            let sectionIndex = HomeSection.topRestaurants.rawValue
            sectionsToUpdate.insert(sectionIndex)
        }
        if let forMeRestaurants = lists.restaurantsForMe, !forMeRestaurants.isEmpty {
            viewModel.forMeRestaurants = forMeRestaurants.compactMap({ $0 })
            let sectionIndex = HomeSection.forMeRestaurants.rawValue
            sectionsToUpdate.insert(sectionIndex)
        }
        return sectionsToUpdate
    }
    
    private func reloadData(sectionsToUpdate: IndexSet) {
        Task {
            await homeMainCollectionViewHandler?.reloadData()
            await homeMainCollectionViewHandler?.reloadSections(sectionsToUpdate)
        }
    }
}
