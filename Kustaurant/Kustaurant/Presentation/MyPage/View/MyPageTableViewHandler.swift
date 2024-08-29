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
    
    func setupTableView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.separatorStyle = .none
        view.tableView.registerCell(ofType: MyPageViewTableViewCell.self)
        view.tableView.showsVerticalScrollIndicator = false
        view.tableView.tableHeaderView = headerView
        view.tableView.contentInsetAdjustmentBehavior = .never
    }
}

extension MyPageTableViewHandler: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
