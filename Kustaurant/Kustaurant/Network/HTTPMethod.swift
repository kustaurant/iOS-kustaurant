//
//  HTTPMethod.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let delete = HTTPMethod(rawValue: "DELETE")
    public static let patch = HTTPMethod(rawValue: "PATCH")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

