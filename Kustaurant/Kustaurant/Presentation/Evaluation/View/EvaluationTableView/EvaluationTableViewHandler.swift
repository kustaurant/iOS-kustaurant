//
//  EvaluationTableViewHandler.swift
//  Kustaurant
//
//  Created by 송우진 on 9/6/24.
//

import UIKit

final class EvaluationTableViewHandler: NSObject {
    private var view: EvaluationView
    private var viewModel: EvaluationViewModel
    private var keywordHandler: EvaluationKeywordCollectionViewHandler?
    
    // MARK: - Initialization
    init(
        view: EvaluationView,
        viewModel: EvaluationViewModel
    ) {
        self.view = view
        self.viewModel = viewModel
        super.init()
        setupTalbieView()
    }
}

extension EvaluationTableViewHandler {
    private func setupTalbieView() {
        view.tableView.delegate = self
        view.tableView.dataSource = self
    }
    
    func keywordReload() {
        keywordHandler?.reload()
    }
}

// MARK: - UITableViewDelegate
extension EvaluationTableViewHandler: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension EvaluationTableViewHandler: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        EvaluationSection.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let section = EvaluationSection(index: indexPath.section)
        else { return .init() }

        switch section {
        case .title:
            let cell: EvaluationTitleCell = tableView.dequeueReusableCell(for: indexPath)
            cell.update(item: viewModel.restaurantDetailTitle)
            return cell
            
        case .keyword:
            let cell: EvaluationKeywordCell = tableView.dequeueReusableCell(for: indexPath)
            keywordHandler = EvaluationKeywordCollectionViewHandler(view: cell, viewModel: viewModel)
            return cell
            
        case .rating:
            let cell: EvaluationRatingCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
}
