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
    private let tierCellHeightSubject: CurrentValueSubject<CGFloat, Never> = .init(0)
    private var tabCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.state = .fetch
        bind()
        setupTableView()
        setupLayout()
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderTopPadding = 0
        
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        
        tableView.registerCell(ofType: RestaurantDetailTitleCell.self)
        tableView.registerCell(ofType: RestaurantDetailTierInfoCell.self)
        tableView.registerCell(ofType: RestaurantDetailAffiliateInfoCell.self)
        tableView.registerCell(ofType: RestaurantDetailRatingCell.self)
        tableView.registerCell(ofType: RestaurantDetailMenuCell.self)
        tableView.registerCell(ofType: RestaurantDetailCommentCell.self)
        tableView.registerCell(ofType: RestaurantDetailReviewCell.self)
        
        tableView.registerHeaderFooterView(ofType: RestaurantDetailTabSectionHeaderView.self)
    }
    
    private func setupLayout() {
        view.addSubview(tableView, autoLayout: [.fill(0)])
    }
    
    private func bind() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .didFetchItems:
                    self?.tableView.reloadData()
                    
                case .didFetchHeaderImage(let image):
                    self?.tableView.tableHeaderView = UIImageView(image: image)
                    
                case .didFetchReviews, .didChangeTabType:
                    self?.tableView.reloadSections(.init(integer: RestaurantDetailSection.tab.index), with: .none)
                }
            }
            .store(in: &cancellables)
        
        tierCellHeightSubject
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard RestaurantDetailSection(index: section) == .tab
        else { return .zero }
        
        return KuTabBarView.height + 26
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard RestaurantDetailSection(index: indexPath.section) == .tier else {
            return UITableView.automaticDimension
        }
        
        return tierCellHeightSubject.value
    }
}

extension RestaurantDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        RestaurantDetailSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detailSection = RestaurantDetailSection(index: section),
              let items = viewModel.detail?.items[detailSection]
        else { return 0 }
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let detailSection = RestaurantDetailSection(index: section)
        else { return nil }
        
        switch detailSection {
        case .tab:
            let headerView: RestaurantDetailTabSectionHeaderView = tableView.dequeueReusableHeaderFooterView()
            tabCancellable = headerView.update(selectedIndex: viewModel.detail?.tabType.rawValue ?? 0)
                .sink { [weak self] type in
                    guard let type else { return }
                    self?.viewModel.state = .didTab(at: type)
                }
            return headerView
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailSection = RestaurantDetailSection(index: indexPath.section),
              let items = viewModel.detail?.items[detailSection],
              let item = items[safe: indexPath.row]
        else { return .init() }
        
        switch detailSection {
        case .title:
            let cell: RestaurantDetailTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            return cell
            
        case .tier:
            let cell: RestaurantDetailTierInfoCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item, tierCellHeightSubject: tierCellHeightSubject)
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
        guard let tabType = viewModel.detail?.tabType else { return .init() }
        switch tabType {
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
