//
//  TierMapBottomSheet.swift
//  Kustaurant
//
//  Created by 송우진 on 8/21/24.
//

import UIKit

protocol TierMapBottomSheetDelegate: AnyObject {
    func bottomSheetDidDismiss()
}

final class TierMapBottomSheet: UIViewController {
    weak var delegate: TierMapBottomSheetDelegate?
    private let sheetView: TierMapBottomSheetView = TierMapBottomSheetView()
    
    // MARK: - Life Cycle
    override func loadView() {
        view = sheetView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageSheet()
    }
}

extension TierMapBottomSheet {
    private func configurePageSheet() {
        modalPresentationStyle = .pageSheet
        isModalInPresentation = false
        if let sheet = sheetPresentationController {
            let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
            let detent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in 139 }
            sheet.detents = [detent]
            sheet.largestUndimmedDetentIdentifier = .init(detentIdentifier)
            sheet.prefersGrabberVisible = true
            sheet.delegate = self
        }
    }
    
    func configure(with restaurant: Restaurant) {
        sheetView.update(restaurant)
    }
}

extension TierMapBottomSheet: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.bottomSheetDidDismiss()
    }
}
