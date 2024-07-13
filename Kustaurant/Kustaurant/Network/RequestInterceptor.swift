//
//  RequestInterceptor.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public protocol RequestInterceptor {
    func intercept(_ request: URLRequest) -> URLRequest
}
