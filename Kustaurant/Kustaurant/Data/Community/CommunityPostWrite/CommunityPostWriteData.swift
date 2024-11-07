//
//  CommunityPostWriteData.swift
//  Kustaurant
//
//  Created by 송우진 on 11/7/24.
//

import Foundation

actor CommunityPostWriteData {
    private(set) var title: String?
    private(set) var content: String?
    private(set) var category: CommunityPostCategory = .all
    private(set) var imageData: Data?
    private(set) var imageFile: String?
    
    var isComplete: Bool {
        if let title = title, !title.isEmpty,
           let content = content, !content.isEmpty,
           category != .all
        {
            return true
        }
        return false
    }
    
    init() {}
    
    func updateCategory(_ category: CommunityPostCategory) {
        self.category = category
    }
    
    func updateTitle(_ title: String?) {
        self.title = title
    }
    
    func updateContent(_ content: String?) {
        self.content = content
    }
    
    func updateImageFile(_ imageFile: String?) {
        self.imageFile = imageFile
    }
    
    func updateImageData(_ imageData: Data?) {
        self.imageData = imageData
    }
}
