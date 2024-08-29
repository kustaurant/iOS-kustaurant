//
//  MyPageTableViewSection.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/28/24.
//

import Foundation

enum MyPageTableViewItemType {
    case savedRestaurants
    case termsOfService
    case sendFeedback
    case notice
    case privacyPolicy
    case logout
    case deleteAccount
}

struct MyPageTableViewItem {
    let type: MyPageTableViewItemType
    let title: String
    let iconNamePrefix: String
}

struct MyPageTableViewSection {
    let id: String
    let items: [MyPageTableViewItem]
    let footerHeight: Int
}
