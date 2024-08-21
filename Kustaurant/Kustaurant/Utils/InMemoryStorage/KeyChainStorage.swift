//
//  KeyChaingStorage.swift
//  Kustaurant
//
//  Created by peppermint100 on 8/18/24.
//

import Foundation
import Security

final class KeychainStorage: KeyValueStorage {
    
    private init() {}
    static let shared = KeychainStorage()
    
    @discardableResult
    func setValue<T: Codable>(_ value: T?, forKey key: String) -> Bool {
            guard let value = value else { return false }
            
            do {
                let data = try JSONEncoder().encode(value)
                
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data
                ]
                
                SecItemDelete(query as CFDictionary)
                let status = SecItemAdd(query as CFDictionary, nil)
                
                return status == errSecSuccess
            } catch {
                print("Error encoding value for key \(key): \(error)")
                return false
            }
        }
        
        func getValue<T: Codable>(forKey key: String) -> T? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: kCFBooleanTrue!,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            
            var dataTypeRef: AnyObject? = nil
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            
            guard status == errSecSuccess, let data = dataTypeRef as? Data else { return nil }
            
            do {
                let decodedValue = try JSONDecoder().decode(T.self, from: data)
                return decodedValue
            } catch {
                print("Error decoding value for key \(key): \(error)")
                return nil
            }
        }
    
    @discardableResult
    func removeValue(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        return status == errSecSuccess
    }
}
