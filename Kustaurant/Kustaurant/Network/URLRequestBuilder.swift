//
//  URLRequestBuilder.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public struct URLRequestBuilder {
    private var url: URL?
    private var method: HTTPMethod
    private var headers: [String: String] = [:]
    private var body: Data?
    
    public init(url: String, method: HTTPMethod = .get) {
        self.url = URL(string: url)
        self.method = method
    }
    
    @discardableResult
    public mutating func addHeader(field: String, value: String) -> URLRequestBuilder {
        headers[field] = value
        return self
    }
    
    @discardableResult
    public mutating func addHeaders(_ headers: [String: String]) -> URLRequestBuilder {
        self.headers.merge(headers, uniquingKeysWith: { (_, new) in new } )
        return self
    }
    
    @discardableResult
    public mutating func removeHeader(forField field: String) -> URLRequestBuilder {
        headers[field] = nil
        return self
    }
    
    @discardableResult
    public mutating func removeAllHeaders() -> URLRequestBuilder {
        headers.removeAll()
        return self
    }
    
    @discardableResult
    public mutating func setBody(_ body: Data?) -> URLRequestBuilder {
        self.body = body
        return self
    }
    
    @discardableResult
    public mutating func addPath(_ path: String) -> URLRequestBuilder {
        url?.append(path: path)
        return self
    }
    
    @discardableResult
    public mutating func addQuery(parameter: [String: String]) -> URLRequestBuilder {
        guard let url = self.url else { return self }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.percentEncodedQuery = parameter
            .map { $0.key + "=" + $0.value }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = components?.url
        return self
    }
    
    public func build() -> URLRequest? {
        guard let url = url else { return nil }
        
        var request: URLRequest = .init(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}

enum RequestContentType: String {
    case applicationJson = "application/json"
    case textPlain = "text/plain"
}

extension URLRequestBuilder {
    mutating func addContentType(_ contentType: RequestContentType) {
        self.addHeader(field: "Content-Type", value: contentType.rawValue)
    }
}
