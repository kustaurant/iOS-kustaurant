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
}

// MARK: - UITableViewDelegate
extension EvaluationTableViewHandler: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        150
//        UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension EvaluationTableViewHandler: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        EvaluationSection.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test", for: indexPath)
        let colors: [UIColor] = [.blue, .red, .gray, .green, .yellow]
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = colors.randomElement()?.withAlphaComponent(0.5)
        
        return cell
    }
}
