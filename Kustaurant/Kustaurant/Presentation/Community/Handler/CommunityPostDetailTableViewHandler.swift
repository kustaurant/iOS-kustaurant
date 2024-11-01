//
//  CommunityPostDetailTableViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 10/28/24.
//

import UIKit

final class CommunityPostDetailTableViewHandler: NSObject {
    private typealias DataSource = UITableViewDiffableDataSource<CommunityPostDetailSection, AnyHashable>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<CommunityPostDetailSection, AnyHashable>
    
    private let tableView: UITableView
    private let viewModel: CommunityPostDetailViewModel
    private lazy var dataSource: DataSource = setDataSource()
    
    init(
        tableView: UITableView,
        viewModel: CommunityPostDetailViewModel
    ) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        configureTableView()
    }
    
    func update() {
        applySnapShot()
    }
}

extension CommunityPostDetailTableViewHandler {
    private func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    private func applySnapShot() {
        Task { @MainActor in
            let items = await self.viewModel.detail.getCellItems(.body).map({ $0 as? AnyHashable }).compactMap({ $0 })
            let comments = await self.viewModel.detail.getCellItems(.comment).map({ $0 as? AnyHashable }).compactMap({ $0})
            
            var snapShot = SnapShot()
            snapShot.appendSections([.body, .comment])
            snapShot.appendItems(items, toSection: .body)
            snapShot.appendItems(comments, toSection: .comment)
            await dataSource.apply(snapShot, animatingDifferences: false)
        }
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            
            if let item = itemIdentifier as? CommunityPostDetailBody {
                let cell = tableView.dequeueReusableCell(for: indexPath) as CommunityPostDetailBodyCell
                cell.update(item)
                cell.likeButtonTouched = { [weak self] in
                    self?.viewModel.process(.touchLikeButton)
                }
                cell.scrapButtonTouched = { [weak self] in
                    self?.viewModel.process(.touchScrapButton)
                }
                return cell
            }
            
            if let item = itemIdentifier as? CommunityPostDTO.PostComment {
                let cell = tableView.dequeueReusableCell(for: indexPath) as CommunityPostDetailCommentCell
                cell.update(item)
                return cell
            }
            
            return UITableViewCell()
        }
        return dataSource
    }
}

// MARK: UITableViewDelegate
extension CommunityPostDetailTableViewHandler: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        Logger.info("\(indexPath)", category: .none)
    }
}
