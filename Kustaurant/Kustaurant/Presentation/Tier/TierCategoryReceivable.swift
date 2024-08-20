//
//  TierCategoryReceivable.swift
//  Kustaurant
//
//  Created by 송우진 on 8/18/24.
//

import Foundation

protocol TierCategoryReceivable: AnyObject {
    func receiveTierCategories(categories: [Category])
}
