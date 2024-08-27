//
//  Request.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public class Request {
    
    let session: URLSession
    let interceptor: RequestInterceptor?
    let retrier: RequestRetrier?
    
    public init(session: URLSession, interceptor: RequestInterceptor?, retrier: RequestRetrier?) {
        self.session = session
        self.interceptor = interceptor
        self.retrier = retrier
    }
}

extension Request {
    
    func execute(with urlRequest: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        session.dataTask(with: urlRequest) { data, urlResponse, error in
            if let error {
                completionHandler(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200..<300:
                break
            case 400:
                completionHandler(.failure(.badRequest))
                return
            case 401:
                completionHandler(.failure(.unauthorized))
                return
            case 403:
                completionHandler(.failure(.forbidden))
                return
            default:
                completionHandler(.failure(.serverError(statusCode: statusCode)))
                return
            }
            
            guard let data else {
                completionHandler(.failure(.noData))
                return
            }
            
            completionHandler(.success(data))
        }.resume()
    }
    
    func execute(with urlRequest: URLRequest, attempt: Int, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = interceptor?.intercept(urlRequest) ?? urlRequest
        var attempt = attempt
        
        execute(with: urlRequest) { [weak self] result in
            repeat {
                switch result {
                case .success(let data):
                    completionHandler(.success(data))
                    return
                case .failure(let error):
                    guard
                        let retrier = self?.retrier,
                        retrier.shouldRetry(request, with: error, attempt: attempt)
                    else {
                        completionHandler(.failure(error))
                        return
                    }
                    
                    attempt += 1
                }
            } while true
        }
    }
    
    func execute(with urlRequest: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            execute(with: urlRequest) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func execute(with urlRequest: URLRequest, attempt: Int) async throws -> Data {
        var attempt = attempt
        
        repeat {
            do {
                let request = interceptor?.intercept(urlRequest) ?? urlRequest
                let data = try await execute(with: request)
                return data
            } catch {
                guard
                    let retrier = retrier,
                    await retrier.shouldRetryAsync(with: error, attempt: attempt)
                else {
                    throw error
                }
                
                attempt += 1
            }
        } while true
    }
}

extension Request {
    
    public func response(with urlRequest: URLRequest, completion: @escaping (Response) -> Void) {
        execute(with: urlRequest) { result in
            switch result {
            case .success(let data):
                completion(.init(data: data, error: nil))
            case .failure(let error):
                completion(.init(data: nil, error: error))
            }
        }
    }
    
    public func responseAsync(with urlRequest: URLRequest) async -> Response {
        do {
            let data = try await execute(with: urlRequest, attempt: 0)
            
            return .init(data: data, error: nil)
        } catch {
            guard let error = error as? NetworkError
            else {
                return .init(data: nil, error: .custom(error.localizedDescription))
            }
            return .init(data: nil, error: error)
        }
    }
    
    public func response(with urlRequestBuilder: URLRequestBuilder, completion: @escaping (Response) -> Void) {
        guard let urlRequest = urlRequestBuilder.build()
        else {
            completion(.init(data: nil, error: .invalidRequest))
            return
        }
        
        response(with: urlRequest, completion: completion)
    }
    
    public func responseAsync(with urlRequestBuilder: URLRequestBuilder) async -> Response {
        guard let urlRequest = urlRequestBuilder.build()
        else { return .init(data: nil, error: .invalidRequest) }
        
        return await responseAsync(with: urlRequest)
    }
}
