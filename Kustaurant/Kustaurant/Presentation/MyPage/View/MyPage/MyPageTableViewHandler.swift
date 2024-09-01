//
//  MyPageTableViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/28/24.
//

import UIKit

final class MyPageTableViewHandler: NSObject {
    
    private let view: MyPageView
    private let viewModel: MyPageViewModel
    let headerView = MyPageUserProfileView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 320))
    
    init(view: MyPageView, viewModel: MyPageViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
}

extension MyPageTableViewHandler {
    
    func setupTableView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.separatorStyle = .none
        view.tableView.registerCell(ofType: MyPageViewTableViewCell.self)
        view.tableView.showsVerticalScrollIndicator = false
        view.tableView.tableHeaderView = headerView
        view.tableView.contentInsetAdjustmentBehavior = .never
    }
    
    func updateUI(by loginStatus: LoginStatus) {
        headerView.profileImageView.image = UIImage(named: loginStatus.profileImageName)
        headerView.profileButton.configuration = loginStatus.profileButtonConfiguration
        
        if loginStatus == .notLoggedIn {
            headerView.profileButton.setTitle("로그인하고 시작하기", for: .normal)
        }
        
        for sectionIndex in 0..<viewModel.tableViewSections.count {
            let section = viewModel.tableViewSections[sectionIndex]
            for row in 0..<section.items.count {
                let item = section.items[row]
                let indexPath = IndexPath(row: row, section: sectionIndex)
                if let cell = view.tableView.cellForRow(at: indexPath) as? MyPageViewTableViewCell {
                    cell.iconImageView.image = UIImage(named: item.iconNamePrefix + loginStatus.iconNamePostfix)
                    cell.titleLabel.textColor = loginStatus.textColor
                }
            }
        }
    }
    
    func updateSavedRestaurants(_ userSavedRestaurants: UserSavedRestaurantsCount) {
        headerView.profileButton.setTitle(userSavedRestaurants.nickname, for: .normal)
        headerView.myEvaluationCountLabel.text = String(describing: userSavedRestaurants.evaluationCount ?? 0)
        headerView.myFavoriteRestaurantCountLabel.text = String(describing: userSavedRestaurants.favoriteCount ?? 0)
        if 
            let imgUrlString = userSavedRestaurants.iconImgUrl,
            let imgUrl = URL(string: imgUrlString) {
            ImageCacheManager.shared.loadImage(from: imgUrl, targetWidth: 77, defaultImage: UIImage(named: "img_babycow")) { [weak self] image in
                self?.headerView.profileImageView.image = image
            }
        }
    }
}

extension MyPageTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isLoggedIn == .notLoggedIn { return }
        let item = viewModel.tableViewSections[indexPath.section].items[indexPath.row]
        switch item.type {
        case .savedRestaurants:
            viewModel.didTapSavedRestaurantsCell()
        case .sendFeedback:
            viewModel.didTapSendFeedback()
        case .notice:
            viewModel.didTapNotice()
        case .termsOfService:
            viewModel.didTapTermsOfService()
        case .privacyPolicy:
            viewModel.didTapPrivacyPolicy()
        case .logout:
            viewModel.didTapLogoutButton()
        case .deleteAccount:
            viewModel.didTapDeleteAccount()
        }
    }
}

extension MyPageTableViewHandler: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.tableViewSections[section].footerHeight)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableViewSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageViewTableViewCell.reuseIdentifier) as? MyPageViewTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.tableViewSections[indexPath.section].items[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
}
