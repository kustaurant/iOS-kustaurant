//
//  DrawResultViewController.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/10/24.
//

import UIKit

class DrawResultViewController: UIViewController {
    
    private var viewModel: DrawResultViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    init(viewModel: DrawResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
