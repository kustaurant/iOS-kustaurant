//
//  AlertPayload.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/30/24.
//

import Foundation

struct AlertPayload {
    let title: String
    let subtitle: String
    let onConfirm: (() -> Void)?
    
    static func empty() -> AlertPayload {
        .init(title: "", subtitle: "", onConfirm: nil)
    }
}
