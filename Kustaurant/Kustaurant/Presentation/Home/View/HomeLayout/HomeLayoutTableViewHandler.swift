//
//  HomeLayoutTableViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 8/5/24.
//

import UIKit

final class HomeLayoutTableViewHandler: NSObject {
    private var view: HomeView
    private var viewModel: HomeViewModel
    private var restaurantsHandlerDic: [HomeSection : HomeRestaurantsCollectionViewHandler?] = [
        .topRestaurants : nil,
        .forMeRestaurants : nil
    ]
    
    // MARK: - Initialization
    init(
        view: HomeView,
        viewModel: HomeViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setup()
    }
}

extension HomeLayoutTableViewHandler {
    private func setup() {
        view.homeLayoutTableView.delegate = self
        view.homeLayoutTableView.dataSource = self
    }
    
    private func sectionType(indexPath: IndexPath) -> HomeSection? {
        HomeSection(rawValue: indexPath.row)
    }
    
    func reloadSection(_ section: HomeSection) {
        switch section {
        case .banner:
            return
        case .categories:
            return
        case .topRestaurants, .forMeRestaurants:
            if let handler = restaurantsHandlerDic[section] {
                handler?.reload()
            }
        }
    }
}

extension HomeLayoutTableViewHandler: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch sectionType(indexPath: indexPath) {
        case .forMeRestaurants, .topRestaurants: return HomeRestaurantsSection.sectionHeight + HomeRestaurantsSection.sectionBottomInset
        default: return 100
        }
    }
}

extension HomeLayoutTableViewHandler: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.mainSections.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = sectionType(indexPath: indexPath)
        switch section {
        case .topRestaurants, .forMeRestaurants:
            let cell = tableView.dequeueReusableCell(withReuseIdentifier: HomeRestaurantsSection.reuseIdentifier) as HomeRestaurantsSection
            cell.sectionType = section
            restaurantsHandlerDic[section!] = HomeRestaurantsCollectionViewHandler(view: cell, viewModel: viewModel)
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withReuseIdentifier: "Default")
            cell.backgroundColor = .purple
            cell.layer.borderWidth = 1.0
            return cell
        }
    }
}
