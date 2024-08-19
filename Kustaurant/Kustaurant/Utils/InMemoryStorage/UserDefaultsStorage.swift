//
//  UserDefaultsStorage.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation

final class UserDefaultsStorage: KeyValueStorage {
    
    private let defaults = UserDefaults.standard
    
    func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool {
        guard let value = value else {
            defaults.removeObject(forKey: key)
            return true
        }
        
        do {
            let data = try JSONEncoder().encode(value)
            defaults.set(data, forKey: key)
            return true
        } catch {
            print("Error encoding value for key \(key): \(error)")
            return false
        }
    }
    
    func getValue<T: Codable>(forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        
        do {
            let decodedValue = try JSONDecoder().decode(T.self, from: data)
            return decodedValue
        } catch {
            print("Error decoding value for key \(key): \(error)")
            return nil
        }
    }
    
    func removeValue(forKey key: String) -> Bool {
        defaults.removeObject(forKey: key)
        return true
    }
}

