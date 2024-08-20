//
//  KeyValueStroe.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

protocol KeyValueStorage {
    func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool
    func getValue<T: Codable>(forKey key: String) -> T?
    func removeValue(forKey key: String) -> Bool
}
