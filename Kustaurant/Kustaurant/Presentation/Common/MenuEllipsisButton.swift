//
//  MenuEllipsisButton.swift
//  Kustaurant
//
//  Created by 송우진 on 11/4/24.
//

import UIKit

final class EllipsisMenuButton: UIButton {
    var onReportAction: (() -> Void)?
    var onDeleteAction: (() -> Void)?
    
    var isMine: Bool = false {
        didSet {
            setupMenu()
        }
    }
    var isReportHidden: Bool = false {
        didSet {
            setupMenu(isReportHidden: true)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EllipsisMenuButton {
    private func setupStyle() {
        setImage(UIImage(named: "icon_ellipsis"), for: .normal)
        tintColor = .Sementic.gray75
    }
    
    private func setupMenu(isReportHidden: Bool = false) {
        var actions: [UIAction] = []
        
        if !isReportHidden {
            let reportAction = UIAction(title: "신고하기", image: UIImage(named: "icon_shield")) { [weak self] _ in
                self?.onReportAction?()
            }
            actions.append(reportAction)
        }
        
        
        if isMine {
            let deleteAction = UIAction(title: "삭제하기", image: UIImage(named: "icon_trash"), attributes: .destructive) { [weak self] _ in
                self?.onDeleteAction?()
            }
            actions.append(deleteAction)
        }
        
        let menu = UIMenu(title: "", children: actions)
        self.menu = menu
        self.showsMenuAsPrimaryAction = true
    }
}
