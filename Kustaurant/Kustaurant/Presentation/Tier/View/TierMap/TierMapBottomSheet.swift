//
//  TierMapBottomSheet.swift
//  Kustaurant
//
//  Created by 송우진 on 8/21/24.
//

import UIKit

final class TierMapBottomSheet: UIViewController {
    private var restaurant: Restaurant?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageSheet()
        view.backgroundColor = .mainGreen
    }
}

extension TierMapBottomSheet {
    private func configurePageSheet() {
        modalPresentationStyle = .pageSheet
        isModalInPresentation = true
        if let sheet = sheetPresentationController {
            let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
            let detent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in 139 }
            sheet.detents = [detent]
            sheet.largestUndimmedDetentIdentifier = .init(detentIdentifier)
            sheet.prefersGrabberVisible = true
        }
    }
}
