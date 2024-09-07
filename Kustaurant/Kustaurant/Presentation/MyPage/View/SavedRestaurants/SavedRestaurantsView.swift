//
//  SavedRestaurantsView.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/29/24.
//

import UIKit

class SavedRestaurantsView: UIView {
    
    let tableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    let emptyView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 26
        sv.isHidden = true
        return sv
    }()
    
    private let kuImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "icon_ku_grayed")
        return iv
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 저장된 맛집이 없어요."
        label.font = .Pretendard.semiBold17
        label.textColor = .Sementic.gray300
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SavedRestaurantsView {
    
    private func setupUI() {
        addSubview(tableView, autoLayout: [.fill(0)])
        addSubview(emptyView, autoLayout: [.fill(0)])
        emptyView.addSubview(kuImageView, autoLayout: [.topSafeArea(constant: 191), .width(62), .height(71), .centerX(0)])
        emptyView.addSubview(emptyLabel, autoLayout: [.topNext(to: kuImageView, constant: 26), .fillX(0)])
    }
}
