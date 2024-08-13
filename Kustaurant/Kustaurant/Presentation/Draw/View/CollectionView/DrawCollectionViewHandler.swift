//
//  DrawCollectionViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/9/24.
//

import UIKit

final class DrawCollectionViewHandler: NSObject {
    
    private let view: DrawView
    private let viewModel: DrawViewModel
    private var dataSource: UICollectionViewDiffableDataSource<DrawCollectionViewType, DrawCollectionViewItem>?
    
    init(view: DrawView, viewModel: DrawViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

// MARK: Internal Method
extension DrawCollectionViewHandler {
    
    func setupCollectionView() {
        let cv = view.collectionView
        let layout = createLayout()
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false
        cv.collectionViewLayout = layout
        cv.register(DrawLocationCollectionViewCell.self, forCellWithReuseIdentifier: DrawLocationCollectionViewCell.reuseIdentifier)
        cv.register(DrawCuisineCollectionViewCell.self, forCellWithReuseIdentifier: DrawCuisineCollectionViewCell.reuseIdentifier)
        setDataSource()
    }
    
    func applySnapshot(sectionModels: [DrawCollectionViewSection]) {
        guard let dataSource = dataSource else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<DrawCollectionViewType, DrawCollectionViewItem>()
        
        for sectionModel in sectionModels {
            let section = sectionModel.type
            snapshot.appendSections([section])
            snapshot.appendItems(sectionModel.items, toSection: section)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: DataSource
extension DrawCollectionViewHandler {
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: view.collectionView , cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .monoHorizontal(let location):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawLocationCollectionViewCell.reuseIdentifier, for: indexPath)
                            as? DrawLocationCollectionViewCell else { return UICollectionViewCell() }
                    cell.configure(with: location)
                    return cell
                case .grid(let cuisine):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawCuisineCollectionViewCell.reuseIdentifier, for: indexPath)
                            as? DrawCuisineCollectionViewCell else { return UICollectionViewCell() }
                    cell.configure(with: cuisine)
                    return cell
                }
            })
    }
}

// MARK: Layout
extension DrawCollectionViewHandler {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIdx, _ in
            let section = self?.dataSource?.sectionIdentifier(for: sectionIdx)
            
            switch section {
            case .location:
                return self?.createLocationSection()
            case .cuisine:
                return self?.createCuisineSection()
            default:
                return self?.createLocationSection()
            }
        }
        
        return layout
    }
    
    private func createLocationSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(Category.Height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(Category.Height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: viewModel.locations.count))
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func createCuisineSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalWidth(0.305))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.305))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: 4))
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        return section
    }
}

// MARK: Delegate
extension DrawCollectionViewHandler: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.collectionViewSections[indexPath.section]
        
        UIView.performWithoutAnimation {
            switch section.type {
            case .location:
                if case let .monoHorizontal(location) = section.items[indexPath.row] {
                    viewModel.toggleSelectable(location: location)
                }
            case .cuisine:
                if case let .grid(cuisine) = section.items[indexPath.row] {
                    viewModel.toggleSelectable(cuisine: cuisine)
                }
            }
        }
    }
}

