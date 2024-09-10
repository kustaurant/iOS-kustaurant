//
//  NoticeBoardTableViewHandler.swift
//  Kustaurant
//
//  Created by peppermint100 on 9/1/24.
//

import UIKit

final class NoticeBoardTableViewHandler: NSObject {
    
    private let view: NoticeBoardView
    private let viewModel: NoticeBoardViewModel
    
    init(view: NoticeBoardView, viewModel: NoticeBoardViewModel) {
        self.view = view
        self.viewModel = viewModel
    }
    
    func setupTableView() {
        view.tableView.showsVerticalScrollIndicator = false
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.registerCell(ofType: NoticeTitleTableViewCell.self)
        view.tableView.registerCell(ofType: NoticeContentTableViewCell.self)
    }
    
    func reloadData() {
        view.tableView.reloadData()
    }
}

extension NoticeBoardTableViewHandler: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            let section = viewModel.noticeList[indexPath.section]
            section.isExpanded.toggle()
            tableView.reloadSections(.init(integer: indexPath.section), with: .fade)
        }
    }
}

extension NoticeBoardTableViewHandler: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            90
        } else {
            UIScreen.main.bounds.height - 90
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.noticeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = viewModel.noticeList[section]
        if section.isExpanded {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTitleTableViewCell.reuseIdentifier) as? NoticeTitleTableViewCell else {
                return UITableViewCell()
            }
            let section = viewModel.noticeList[indexPath.section]
            cell.configure(title: section.notice.noticeTitle, createdAt: section.notice.createdDate)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeContentTableViewCell.reuseIdentifier) as? NoticeContentTableViewCell else {
                return UITableViewCell()
            }
            let section = viewModel.noticeList[indexPath.section]
            if section.isExpanded {
                cell.loadWebView(with: section.notice.noticeLink)
            }
            return cell
        }
    }
}


