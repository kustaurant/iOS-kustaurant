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
    
    var isScrollEnabled: Bool = false {
        didSet {
            collectionView.isScrollEnabled = isScrollEnabled
        }
    }
    
    @Published var state: State = .initial
    private let actionSubject: PassthroughSubject<Action, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = .init()
    
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(tabs: [String], style: Style, selectedIndex: Int = 0) {
        self.tabs = tabs.enumerated().map { index, title in
                .init(title: title, isSelcted: index == selectedIndex)
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
    }
    
    private func setupLayout() {
        addSubview(collectionView, autoLayout: [.fill(0)])
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
        tabs = tabs.enumerated().map { i, tab in
                .init(title: tab.title, isSelcted: i == index)
        }
        collectionView.reloadData()
    }
}

// MARK: View Frame 계산
extension KuTabBarView {
    
    static var height: CGFloat {
        Self.init(tabs: [""], style: .fill).calculateCellSize(of: "hello").height
    }
    
    private func calculateCellSize(of text: String) -> CGSize {
        let label = UILabel()
        label.text = text
        
        let labelSize = label.estimatedSize
        
        return .init(width: labelSize.width + 40, height: labelSize.height + 40)
    }
}

extension KuTabBarView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        actionSubject.send(.didSelect(at: indexPath.row))
        didSelect(at: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellSize = calculateCellSize(of: tabs[safe: indexPath.row]?.title ?? "")
        
        switch style {
        case .fitToContents:
            return cellSize
            
        case .fill:
            return .init(width: UIScreen.main.bounds.width / CGFloat(tabs.count), height: cellSize.height)
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
