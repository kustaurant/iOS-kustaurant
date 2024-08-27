//
//  RequestRetrier.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public protocol RequestRetrier {
    func shouldRetry(_ request: URLRequest, with error: Error, attempt: Int) -> Bool
    func shouldRetryAsync(with error: Error, attempt: Int) async -> Bool
}
