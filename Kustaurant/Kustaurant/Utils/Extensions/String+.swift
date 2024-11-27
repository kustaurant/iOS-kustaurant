//
//  String+.swift
//  Kustaurant
//
//  Created by 송우진 on 11/28/24.
//

import Foundation

extension String {
    func htmlToAttributedString() -> NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
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
    
    func htmlToAttributedStringIgnoringFirstImage() -> NSAttributedString? {
        let firstSentence = components(separatedBy: ".").first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        // 첫 번째 문장에 img 태그가 있는지 확인
        if firstSentence.contains("<img") {
            return nil
        }
        return htmlToAttributedString()
    }
}
