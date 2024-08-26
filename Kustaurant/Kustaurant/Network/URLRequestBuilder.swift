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

extension URLRequestBuilder {
    
    public mutating func addAuthorization() {
        guard let user: KuUser = KeychainStorage.shared.getValue(forKey: KeychainKey.kuUser) else {
            Logger.debug("Fail To Add Authorization Header, No User In keychain", category: .network)
            return
        }
        
        addHeader(field: "Authorization", value: "Bearer \(user.accessToken)")
    }
}
