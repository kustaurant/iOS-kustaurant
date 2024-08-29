//
//  MyPageTableViewSection.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/28/24.
//

import Foundation

struct MyPageTableViewItem {
    let title: String
    let iconNamePrefix: String
}

struct MyPageTableViewSection {
    let id: String
    let items: [MyPageTableViewItem]
    let footerHeight: Int
}
