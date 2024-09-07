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
    private let evaluationFloatingView: EvaluationFloatingView = .init()
    private let commentAccessoryView: CommentAccessoryView = .init()
    
    private let viewModel: RestaurantDetailViewModel
    private let tierCellHeightSubject: CurrentValueSubject<CGFloat, Never> = .init(0)
    private var tabCancellable: AnyCancellable?
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var accessoryViewHandler: RestaurantDetailAccessoryViewHandler?
    
    init(viewModel: RestaurantDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.accessoryViewHandler = RestaurantDetailAccessoryViewHandler(
            viewController: self,
            accessoryView: commentAccessoryView,
            viewModel: viewModel
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state = .fetch
        bind()
        setupTableView()
        setupLayout()
        accessoryViewHandler?.setupAccessoryView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsVerticalScrollIndicator = false
        
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
        view.addSubview(evaluationFloatingView, autoLayout: [.fillX(0), .bottom(0), .height(84)])
        view.addSubview(commentAccessoryView, autoLayout: [.fillX(0), .height(68), .bottomKeyboard(0)])
    }
    
    private func bind() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .didFetchItems:
                    self?.tableView.reloadData()
                    
                case .didFetchReviews, .didChangeTabType:
                    let indexSet = IndexSet(integer: RestaurantDetailSection.tab.index)
                    self?.tableView.reloadSections(indexSet, with: .none)
                    
                case .didFetchHeaderImage(let image):
                    let headerView: RestaurantDetailStretchyHeaderView = .init(frame: .init(x: 0, y: 0, width: self?.view.bounds.width ?? 0, height: 145 + self!.view.safeAreaInsets.top))
                    headerView.update(image: image)
                    if let scrollView = self?.tableView {
                        headerView.update(contentInset: scrollView.contentInset, contentOffset: scrollView.contentOffset)
                    }
                    headerView.layer.zPosition = -1
                    headerView.didTapBackButton = {
                        self?.viewModel.state = .didTapBackButton
                    }
                    headerView.didTapSearchButton = {
                        self?.viewModel.state = .didTapSearchButton
                    }
                    self?.tableView.tableHeaderView = headerView
                    
                case .didFetchEvaluation(let isFavorite, let evalutionCount):
                    self?.evaluationFloatingView.isFavorite = isFavorite
                    self?.evaluationFloatingView.evaluationCount = evalutionCount
                    
                case .loginStatus(let loginStatus):
                    self?.evaluationFloatingView.loginStatus = loginStatus
                    self?.evaluationFloatingView.onTapEvaluateButton = { [weak self] in
                        self?.viewModel.state = .didTapEvaluationButton
                    }
                    self?.evaluationFloatingView.onTapFavoriteButton = { [weak self] in
                        self?.viewModel.state = .didTapFavoriteButton
                    }
                    
                case .didSuccessLikeOrDisLikeButton(let commentId, let likeCount, let dislikeCount, let likeStatus):
                    guard let self = self else { return }
                    for cell in self.tableView.visibleCells {
                        if let commentCell = cell as? RestaurantDetailReviewCellType, commentCell.item?.commentId == commentId {
                            commentCell.updateReviewView(likeCount: likeCount, dislikeCount: dislikeCount, likeStatus: likeStatus)
                        }
                    }
                    
                case .showAlert(let payload):
                    self?.presentAlert(payload: payload)
                    
                case .showKeyboard(let commentId):
                    self?.accessoryViewHandler?.showKeyboard(commentId: commentId)
                    
                case .removeComment:
                    self?.tableView.reloadSections([RestaurantDetailSection.tab.index], with: .fade)
                    
                case .addComment:
                    self?.tableView.reloadSections([RestaurantDetailSection.tab.index], with: .automatic)
                    
                case .toggleFavorite(let isFavorite):
                    self?.evaluationFloatingView.isFavorite = isFavorite
                    if isFavorite {
                        self?.evaluationFloatingView.evaluationCount += 1
                    } else {
                        self?.evaluationFloatingView.evaluationCount -= 1
                    }
                }
            }
            .store(in: &cancellables)
        
        tierCellHeightSubject
            .removeDuplicates()
            .sink { [weak self] newHeight in
                guard let self = self else { return }
                if self.tableView.rowHeight != newHeight {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }
            }
            .store(in: &cancellables)
        
        accessoryViewHandler?.sendButtonTapPublisher()
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] payload in
                self?.accessoryViewHandler?.hideKeyboard()
                self?.viewModel.state = .didTapSendButtonInAccessory(payload: payload)
            }
            .store(in: &cancellables)
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard RestaurantDetailSection(index: section) == .tab
        else { return .zero }
        
        return KuTabBarView.height + view.safeAreaInsets.top
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if RestaurantDetailSection(index: indexPath.section) == .tier {
            return tierCellHeightSubject.value
        }
        
        if RestaurantDetailSection(index: indexPath.section) == .rating {
            return 71
        }
        
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tableHeaderView = tableView.tableHeaderView as? RestaurantDetailStretchyHeaderView
        tableHeaderView?.update(contentInset: scrollView.contentInset, contentOffset: scrollView.contentOffset)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let detailSection = RestaurantDetailSection(index: section)
        else { return .init() }
        
        switch detailSection {
        case .tab:
            return 84
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let detailSection = RestaurantDetailSection(index: section)
        else { return .init() }
        
        switch detailSection {
        case .tab:
            let view = UIView()
            view.backgroundColor = .clear
            return view
        default:
            return nil
        }
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
                cell.bind(item: item, indexPath: indexPath, viewModel: viewModel)
                cell.update(item: item)
                return cell
            }
            let cell: RestaurantDetailReviewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.bind(item: item, indexPath: indexPath, viewModel: viewModel)
            cell.update(item: item)
            return cell
        }
    }
}

// MARK: Alert
extension RestaurantDetailViewController {
    
    private func presentAlert(payload: AlertPayload) {
        let alert = UIAlertController(title: payload.title, message: payload.subtitle, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
            payload.onConfirm?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
