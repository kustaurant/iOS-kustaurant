//
//  TierCategoryCollectionViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 7/31/24.
//
import UIKit

final class TierCategoryCollectionViewHandler: NSObject {
    private var view: TierCategoryView
    private var viewModel: TierCategoryViewModel
    
    // MARK: - Initialization
    init(
        view: TierCategoryView,
        viewModel: TierCategoryViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        
        setupCollectionView()
    }
}

extension TierCategoryCollectionViewHandler {
    private func setupCollectionView() {
        view.categoriesCollectionView.delegate = self
        view.categoriesCollectionView.dataSource = self
    }
    
}

// MARK: - UICollectionViewDelegate
extension TierCategoryCollectionViewHandler: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        var category: Category?
        switch indexPath.section {
        case 0: category = viewModel.cuisines[indexPath.row]
        case 1: category = viewModel.situations[indexPath.row]
        case 2: category = viewModel.locations[indexPath.row]
        default: return
        }
        
        guard let category = category else { return }
        viewModel.selectCategories(categories: [category])
    }
}

// MARK: - UICollectionViewDataSource
extension TierCategoryCollectionViewHandler: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderView", for: indexPath) as? SectionHeaderView else { return UICollectionReusableView() }

        switch indexPath.section {
        case 0: header.label.text = "음식"
        case 1: header.label.text = "상황"
        case 2: header.label.text = "위치"
        default: break
        }
        return header
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch section {
        case 0: viewModel.cuisines.count
        case 1: viewModel.situations.count
        case 2: viewModel.locations.count
        default: 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TierListCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as? TierListCategoryCollectionViewCell else { return UICollectionViewCell() }

        var model: Category?
        switch indexPath.section {
        case 0: model = viewModel.cuisines[indexPath.row]
        case 1: model = viewModel.situations[indexPath.row]
        case 2: model = viewModel.locations[indexPath.row]
        default: model = nil
        }
        cell.model = model
        
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TierCategoryCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var category: Category?
        
        switch indexPath.section {
        case 0: category = viewModel.cuisines[indexPath.row]
        case 1: category = viewModel.situations[indexPath.row]
        case 2: category = viewModel.locations[indexPath.row]
        default: category = nil
        }

        let label = UILabel()
        label.text = category?.displayName
        label.font = .pretendard(size: 14, weight: .regular)
        let size = label.intrinsicContentSize
        return CGSize(width: size.width + (TierListCategoryCollectionViewCell.horizontalPadding * 2), height: Category.Height)
    }

}

class SectionHeaderView: UICollectionReusableView {
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
