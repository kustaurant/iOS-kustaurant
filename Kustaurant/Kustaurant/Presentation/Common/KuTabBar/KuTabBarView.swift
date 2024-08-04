//
//  KuTabBarView.swift
//  Kustaurant
//
//  Created by 류연수 on 8/3/24.
//

import UIKit
import Combine

extension KuTabBarView {
    struct Tab {
        let title: String
        let isSelcted: Bool
    }
}

final class KuTabBarView: UIView {
    
    private let collectionView: KuTabBarCollectionView = .init()
    private var tabs: [Tab]
    
    let style: Style
    
    private let indicatorBackgroundView: UIView = .init()
    private let indicatorView: UIView = .init()
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    private var indicatorWidthConstraint: NSLayoutConstraint?
    
    var isScrollEnabled: Bool = false {
        didSet {
            collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    
    @Published var state: State = .initial
    private let actionSubject: CurrentValueSubject<Action, Never> = CurrentValueSubject(.didSelect(at: 0))
    private var cancellabels: Set<AnyCancellable> = .init()
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(tabs: [String], style: Style) {
        self.tabs = tabs.enumerated().map { index, title in
                .init(title: title, isSelcted: index == 0)
        }
        self.style = style
        
        super.init(frame: .zero)
        
        setupStyle()
        setupLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Style {
        case fitToContents
        case fill
    }
    
    enum State {
        case initial
        case tabDidChange(to: Int)
    }
    
    enum Action {
        case didSelect(at: Int)
    }
}

extension KuTabBarView {
    
    private func setupStyle() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        indicatorBackgroundView.backgroundColor = .Sementic.gray200
        indicatorView.backgroundColor = .Signature.green100
    }
    
    private func setupLayout() {
        addSubview(collectionView, autoLayout: [.fill(0)])
        addSubview(indicatorBackgroundView, autoLayout: [.topNext(to: collectionView, constant: 0), .fillX(0), .height(KuTabBarPageController.indicatorViewHeight)])
        addSubview(indicatorView, autoLayout: [.topNext(to: collectionView, constant: 0), .height(KuTabBarPageController.indicatorViewHeight)])
        
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor)
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 100) // 초기 너비는 0으로 설정
        
        NSLayoutConstraint.activate([
            indicatorLeadingConstraint!,
            indicatorWidthConstraint!
        ])
    }
    
    private func bind() {
        $state
            .sink { [weak self] state in
                switch state {
                case .initial: break
                case .tabDidChange(let index):
                    self?.didSelect(at: index)
                }
            }
            .store(in: &cancellabels)
    }
    
    private func didSelect(at index: Int) {
        actionSubject.send(.didSelect(at: index))
        tabs = tabs.enumerated().map { i, tab in
                .init(title: tab.title, isSelcted: i == index)
        }
        updateIndicatorView(at: index, animated: true)
        collectionView.reloadData()
    }
    
    private func updateIndicatorView(at index: Int, animated: Bool) {
        let xPosition = calculateIndicatorViewXPosition(at: index)
        let width = calculateIndicatorViewWidth(at: index)
        
        indicatorLeadingConstraint?.constant = xPosition
        indicatorWidthConstraint?.constant = width
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}

// MARK: View Frame 계산
extension KuTabBarView {
    
    private func calculateLabelSize(of text: String) -> CGSize {
        let label = UILabel()
        label.text = text
        
        return label.systemLayoutSizeFitting(
            CGSize(width: .greatestFiniteMagnitude, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    private func calculateIndicatorViewWidth(at index: Int) -> CGFloat {
        guard index == tabs.count - 1 else {
            return calculateIndicatorViewXPosition(at: index + 1) - calculateIndicatorViewXPosition(at: index)
        }
        
        return collectionView.frame.width - calculateIndicatorViewXPosition(at: index)
    }
    
    private func calculateIndicatorViewXPosition(at index: Int) -> CGFloat {
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = collectionView.cellForItem(at: indexPath) else { return 0 }
        return cell.frame.origin.x - collectionView.contentOffset.x
    }
}

extension KuTabBarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        didSelect(at: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let labelSize = calculateLabelSize(of: tabs[safe: indexPath.row]?.title ?? "")
        
        switch style {
        case .fitToContents:
            return CGSize(width: labelSize.width + 40, height: labelSize.height + 40)
            
        case .fill:
            return .init(width: UIScreen.main.bounds.width / CGFloat(tabs.count), height: labelSize.height + 40)
        }
    }
}

extension KuTabBarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as KuTabBarCollectionViewCell
        let tab = tabs[safe: indexPath.row]
        cell.configure(title: tab?.title ?? "", isSelected: tab?.isSelcted ?? false)
        return cell
    }
}
