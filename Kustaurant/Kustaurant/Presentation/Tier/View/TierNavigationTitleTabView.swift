//
//  TierNavigationTitleTabView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

struct TierTab {
    var title: String
}

protocol TierNavigationTitleTabViewDelegate: AnyObject {
    func tabView(_ tabView: TierNavigationTitleTabView, didSelectTabAt index: Int)
}

final class TierNavigationTitleTabView: UIView {
    private let stackView = UIStackView()
    private let tabModels: [TierTab] = [
        TierTab(title: "티어표"),
        TierTab(title: "지도")
    ]
    private var buttons: [UIButton] = []
    weak var delegate: TierNavigationTitleTabViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Actions
extension TierNavigationTitleTabView {
    private func tabButtonTouched(_ tab: TierTab) {
        guard let index = tabModels.firstIndex(where: { $0.title == tab.title }) else { return }
        updateTabSelection(selectedIndex: index)
        delegate?.tabView(self, didSelectTabAt: index)
    }

    func updateTabSelection(selectedIndex: Int) {
        buttons.enumerated().forEach { (index, button) in
            button.isSelected = index == selectedIndex
        }
    }
}

extension TierNavigationTitleTabView {
    private func setupUI() {
        addSubviews()
        setupConstraint()
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        tabModels.enumerated().forEach { (index, tab) in
            let button = createTab(tab, tag: index)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func createTab(
        _ tab: TierTab,
        tag: Int
    ) -> UIButton {
        let button = UIButton()
        button.tag = tag
        configureButtonAppearance(button, with: tab)
        addButtonAction(button, for: tab)
        return button
    }

    private func configureButtonAppearance(
        _ button: UIButton,
        with tab: TierTab
    ) {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .clear
        
        button.configuration = config
        button.setAttributedTitle(createAttributedString(for: tab.title, selected: true), for: .selected)
        button.setAttributedTitle(createAttributedString(for: tab.title, selected: false), for: .normal)
    }

    private func addButtonAction(
        _ button: UIButton,
        for tab: TierTab
    ) {
        button.addAction(UIAction { [weak self] _ in
            self?.tabButtonTouched(tab)
        }, for: .touchUpInside)
    }

    private func createAttributedString(
        for title: String,
        selected: Bool
    ) -> NSAttributedString {
        let color: UIColor = selected ? .textBlack : .textLightGray
        return NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.Pretendard.semiBold17,
                .foregroundColor: color
            ]
        )
    }
}
