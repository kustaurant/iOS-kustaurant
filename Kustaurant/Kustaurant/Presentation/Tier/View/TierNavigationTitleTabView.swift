//
//  TierNavigationTitleTabView.swift
//  Kustaurant
//
//  Created by 송우진 on 7/23/24.
//

import UIKit

final class TierNavigationTitleTabView: UIView {
    let stackView = UIStackView()
    let tabModels: [TierTab] = [
        TierTab(title: "티어표"),
        TierTab(title: "지도")
    ]
    private var buttons: [UIButton] = []
    
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
    }

    private func updateTabSelection(selectedIndex: Int) {
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
    
    private func createTab(_ tab: TierTab, tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = UIColor.clear
        let attributedStringSelected = NSAttributedString(string: (tab.title ?? ""), attributes: [
            .font: UIFont.pretendard(size: 17, weight: .semibold),
            .foregroundColor: UIColor.textBlack
        ])
        let attributedStringNormal = NSAttributedString(string: (tab.title ?? ""), attributes: [
            .font: UIFont.pretendard(size: 17, weight: .semibold),
            .foregroundColor: UIColor.textLightGray
        ])
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in self?.tabButtonTouched(tab)}, for: .touchUpInside)
        button.setAttributedTitle(attributedStringSelected, for: .selected)
        button.setAttributedTitle(attributedStringNormal, for: .normal)
        return button
    }
}
