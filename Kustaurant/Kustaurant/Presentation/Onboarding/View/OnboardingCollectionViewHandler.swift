//
//  OnboardingCollectionViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/7/24.
//

import UIKit

final class OnboardingCollectionViewHandler: NSObject {
    
    private var view: OnboardingView
    private var viewModel: OnboardingViewModel
    
    init(view: OnboardingView, viewModel: OnboardingViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

extension OnboardingCollectionViewHandler {
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        view.onboardingCollectionView.delegate = self
        view.onboardingCollectionView.dataSource = self
        view.onboardingCollectionView.collectionViewLayout = layout
        view.onboardingCollectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier)
    }
}

extension OnboardingCollectionViewHandler: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2)
        
        let newPage = Int(x / width)
        
        if viewModel.currentOnboardingPage != newPage {
            viewModel.currentOnboardingPage = newPage
        }
    }
}

extension OnboardingCollectionViewHandler: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.onboardingContents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.reuseIdentifier,
            for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(content: viewModel.onboardingContents[indexPath.row])
        return cell
    }
}

// MARK: FlowLayout
extension OnboardingCollectionViewHandler: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: PageControl
extension OnboardingCollectionViewHandler: KuPageControlDelegate {
    
    func setupPageControl() {
        view.pageControl.delegate = self
    }
    
    func didTapIndicator(at page: Int) {
        viewModel.currentOnboardingPage = page
        let offsetX = CGFloat(page) * view.onboardingCollectionView.bounds.width
        view.onboardingCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
