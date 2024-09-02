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
    
    // TODO: - 네트워크 에러 처리 필요
    public func decode<T: Decodable>() -> T? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
