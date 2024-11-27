//
//  String+.swift
//  Kustaurant
//
//  Created by 송우진 on 11/28/24.
//

import Foundation

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
}
