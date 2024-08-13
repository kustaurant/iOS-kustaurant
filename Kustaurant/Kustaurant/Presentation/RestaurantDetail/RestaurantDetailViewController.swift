//
//  RestaurantDetailViewController.swift
//  Kustaurant
//
//  Created by 송우진 on 7/19/24.
//

import UIKit
import Combine

final class RestaurantDetailViewController: UIViewController, NavigationBarHideable {
    
    private let tableView: UITableView = .init()
    
    private let viewModel: RestaurantDetailViewModel
    private var tabCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.state = .fetch(id: 0)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar(animated: false)
    }
}

extension RestaurantDetailViewController {
    
    private func bind() {
        viewModel.actionPublisher
            .sink { [weak self] action in
                switch action {
                case .didChangeTabType:
                    self?.tableView.reloadSections(.init(integer: RestaurantDetailSection.tab.index), with: .none)
                }
            }
            .store(in: &cancellables)
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    
}

extension RestaurantDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        RestaurantDetailSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailSection = RestaurantDetailSection(index: section),
              let items = viewModel.sectionItems[detailSection]
        else { return 0 }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let detailSection = RestaurantDetailSection(index: section),
              let header = viewModel.sectionHeaders[detailSection]
        else { return nil }
        
        switch detailSection {
        case .title:
            let headerView: RestaurantDetailTitleSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
            headerView.update(item: header)
            return headerView
        case .tier, .affiliate:
            let headerView: RestaurantDetailInfoSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
            headerView.update(item: header)
            return headerView
        case .tab:
            let headerView: RestaurantDetailTabSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
            tabCancellable = headerView.actionPublisher
                .sink { [weak self] type in
                    guard let type else { return }
                    self?.viewModel.state = .didTab(at: type)
                }
            return headerView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailSection = RestaurantDetailSection(index: indexPath.section),
              let items = viewModel.sectionItems[detailSection],
              let item = items[safe: indexPath.row]
        else { return .init() }
        
        switch detailSection {
        case .title:
            return .init()
            
        case .tier:
            let cell: RestaurantDetailTierInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
            
        case .affiliate:
            let cell: RestaurantDetailAffiliateInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
            
        case .rating:
            let cell: RestaurantDetailRatingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
            
        case .tab:
            return tabCell(for: indexPath, item: item)
        }
    }
    
    private func tabCell(for indexPath: IndexPath, item: RestaurantDetailCellItem) -> UITableViewCell {
        switch viewModel.tabType {
        case .menu:
            let cell: RestaurantDetailMenuCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
            
        case .review:
            guard let item = item as? RestaurantDetailReview else { return  .init() }
            if item.isComment {
                let cell: RestaurantDetailCommentCell = tableView.dequeueReusableCell(for: indexPath)
                cell.update(item: item)
                return cell
            }
            let cell: RestaurantDetailReviewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
        }
    }
}
