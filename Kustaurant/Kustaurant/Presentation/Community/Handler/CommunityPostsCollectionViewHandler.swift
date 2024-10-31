//
//  CommunityPostsCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 10/14/24.
//

import UIKit

final class CommunityPostsCollectionViewHandler: NSObject {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, CommunityPostDTO>
    private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, CommunityPostDTO>
    
    private enum Section: Int {
        case main
    }
    
    private let collectionView: UICollectionView
    private let viewModel: CommunityViewModel
    private lazy var dataSource: DataSource = setDataSource()
    
    init(
        collectionView: UICollectionView,
        viewModel: CommunityViewModel
    ) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        configureCollectionView()
    }
    
    func update() {
        applySnapShot()
    }
}


extension CommunityPostsCollectionViewHandler {
    private func configureCollectionView() {
        collectionView.collectionViewLayout = setCompositinalLayout()
        collectionView.delegate = self
    }
    
    private func applySnapShot() {
        var snapShot = SnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.posts, toSection: .main)
        dataSource.apply(snapShot)
    }
    
    private func setDataSource() -> DataSource {
        let dataSource: DataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(for: indexPath) as CommunityPostCell
            cell.update(model)
            return cell
        }
        return dataSource
    }
    
    private func setCompositinalLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            CommunityPostCell.layout()
        }
    }
}

extension CommunityPostsCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let totalItems = viewModel.posts.count
        if indexPath.item == (totalItems - 1) {
            viewModel.process(.fetchPostsNextPage)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let post = viewModel.posts[indexPath.row]
        viewModel.process(.didSelectPostCell(post))
    }
}
