//
//  Response.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public class Response {
    public let data: Data?
    public let error: NetworkError?
    
    init(data: Data?, error: NetworkError?) {
        self.data = data
        self.error = error
    }
}

extension Response {
    
    public func decode<T: Decodable>() -> T? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    public func decodeString(encoding: String.Encoding = .utf8) -> String? {
        guard let data else { return nil }
        return String(data: data, encoding: encoding)
    }
}
