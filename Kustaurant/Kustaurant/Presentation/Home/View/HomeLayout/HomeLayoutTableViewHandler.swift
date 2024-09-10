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
    private var bannerHandler: HomeBannerCollectionViewHandler?
    private var categoriesHandler: HomeCategoriesCollectionViewHandler?
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
    
    func reloadTable() {
        view.homeLayoutTableView.reloadData()
    }
    
    func reloadSection(_ section: HomeSection) {
        switch section {
        case .banner:
            bannerHandler?.reload()
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
        case .banner:
            return HomeBannerSection.sectionHeight + HomeBannerSection.sectionBottomInset + HomeBannerSection.sectionTopInset
            
        case .categories:
            return HomeCategoriesSection.sectionHeight + HomeCategoriesSection.sectionBottomInset
            
        case .forMeRestaurants, .topRestaurants:
            return HomeRestaurantsSection.sectionHeight + HomeRestaurantsSection.sectionBottomInset
            
        default: 
            return 0
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
        case .banner:
            let sectionCell = tableView.dequeueReusableCell(withReuseIdentifier: HomeBannerSection.reuseIdentifier) as HomeBannerSection
            sectionCell.bannersCount = viewModel.banners.count
            bannerHandler = HomeBannerCollectionViewHandler(view: sectionCell, viewModel: viewModel)
            return sectionCell
            
        case .categories:
            let sectionCell = tableView.dequeueReusableCell(withReuseIdentifier: HomeCategoriesSection.reuseIdentifier, for: indexPath) as HomeCategoriesSection
            categoriesHandler = HomeCategoriesCollectionViewHandler(view: sectionCell, viewModel: viewModel)
            return sectionCell
            
        case .topRestaurants, .forMeRestaurants:
            let sectionCell = tableView.dequeueReusableCell(withReuseIdentifier: HomeRestaurantsSection.reuseIdentifier, for: indexPath) as HomeRestaurantsSection
            sectionCell.sectionType = section
            restaurantsHandlerDic[section!] = HomeRestaurantsCollectionViewHandler(view: sectionCell, viewModel: viewModel)
            return sectionCell
        
        default:
            return UITableViewCell()
        }
    }
}
