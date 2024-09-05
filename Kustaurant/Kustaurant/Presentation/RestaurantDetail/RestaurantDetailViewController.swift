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
    private let affiliateFloatingView: AffiliabteFloatingView = .init()
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
        viewModel.state = .fetch
        bind()
        setupTableView()
        setupAffiliateFloatingView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func setupAffiliateFloatingView() {
        affiliateFloatingView.backgroundColor = .white
        affiliateFloatingView.onTapEvaluateButton = { [weak self] in
            self?.viewModel.state = .didTapEvaluationButton
        }
    }
    
    private func setupLayout() {
        view.addSubview(tableView, autoLayout: [.fill(0)])
        view.addSubview(affiliateFloatingView, autoLayout: [.fillX(0), .bottom(0), .height(84 + view.safeAreaInsets.bottom)])
        view.addSubview(commentAccessoryView, autoLayout: [.fillX(0), .height(68), .bottomKeyboard(0)])
    }
    
    private func bind() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .didFetchItems, .didFetchReviews, .didChangeTabType:
                    self?.tableView.reloadData()
                    
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
                    
                case .loginStatus(let loginStatus):
                    self?.affiliateFloatingView.evaluateButtonStatus = loginStatus.kuButtonStatus
                    self?.affiliateFloatingView.likeButtonImageName = loginStatus.likeButtonImageResourceName
                    self?.affiliateFloatingView.likeButtonText = "1002명"
                    
                case .didSuccessLikeOrDisLikeButton(let indexPath, let likeCount, let dislikeCount, let likeStatus):
                    guard let commentCell = self?.tableView.cellForRow(at: indexPath) as? RestaurantDetailReviewCellType else {
                        return
                    }
                    commentCell.updateReviewView(likeCount: likeCount, dislikeCount: dislikeCount, likeStatus: likeStatus)
                    return
                    
                case .showAlert(let payload):
                    self?.presentAlert(payload: payload)
                    
                case .showKeyboard(let indexPath, let commentId):
                    self?.accessoryViewHandler?.showKeyboard(indexPath: indexPath, commentId: commentId)
                }
            }
            .store(in: &cancellables)
        
        tierCellHeightSubject
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.tableView.reloadData()
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
                cell.update(item: item)
                
                cell.likeButtonPublisher()
                    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                    .sink { [weak self] in
                        self?.viewModel.state = .didTaplikeCommentButton(indexPath: indexPath, commentId: item.commentId)
                    }
                    .store(in: &cancellables)
                
                cell.dislikeButtonPublisher()
                    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                    .sink { [weak self] in
                        self?.viewModel.state = .didTapDislikeCommentButton(indexPath: indexPath, commentId: item.commentId)
                    }
                    .store(in: &cancellables)
                
                cell.reportTapPublisher()
                    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                    .sink { [weak self] in
                        self?.viewModel.state = .didTapReportComment(indexPath: indexPath, commentId: item.commentId)
                    }
                    .store(in: &cancellables)
                
                cell.deleteTapPublisher()
                    .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                    .sink { [weak self] in
                        self?.viewModel.state = .didTapDeleteComment(indexPath: indexPath, commentId: item.commentId)
                    }
                    .store(in: &cancellables)
                
                cell.commentTapPublisher()
                    .sink { [weak self] in
                        self?.viewModel.state = .didTapCommentButton(indexPath: indexPath, commentId: item.commentId)
                    }
                    .store(in: &cancellables)
                
                
                return cell
            }
            
            let cell: RestaurantDetailReviewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: item)
            cell.likeButtonPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] in
                    self?.viewModel.state = .didTaplikeCommentButton(indexPath: indexPath, commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            cell.dislikeButtonPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] in
                    self?.viewModel.state = .didTapDislikeCommentButton(indexPath: indexPath, commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            cell.reportTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] in
                    self?.viewModel.state = .didTapReportComment(indexPath: indexPath, commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            cell.deleteTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] in
                    self?.viewModel.state = .didTapDeleteComment(indexPath: indexPath, commentId: item.commentId)
                }
                .store(in: &cancellables)
            
            cell.commentTapPublisher()
                .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
                .sink { [weak self] in
                    self?.viewModel.state = .didTapCommentButton(indexPath: indexPath, commentId: item.commentId)
                }
                .store(in: &cancellables)
            
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
