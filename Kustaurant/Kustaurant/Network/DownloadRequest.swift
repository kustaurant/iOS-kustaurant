//
//  DownloadRequest.swift
//  Kustaurant
//
//  Created by 류연수 on 7/13/24.
//

import Foundation

public final class DownloadRequest: Request {
    
    func execute(
        with urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil,
        completionHandler: @escaping (Result<URL, NetworkError>) -> Void
    ) {
        session.downloadTask(with: urlRequest) { [weak self] url, urlResponse, error in
            guard let url else {
                completionHandler(.failure(.custom(error?.localizedDescription ?? URLError(.unknown).localizedDescription)))
                return
            }
            do {
                guard let httpResponse = urlResponse as? HTTPURLResponse,
                      httpResponse.statusCode != 401
                else {
                    completionHandler(.failure(.invalidResponse))
                    return
                }
                
                guard let destinationURL = self?.getFilePath(for: url, directoryURL: directoryURL, fileName: fileName)
                else {
                    completionHandler(.failure(.custom("failed getting file path url")))
                    return
                }
                
                try FileManager.default.moveItem(at: url, to: destinationURL)
                
                completionHandler(.success(destinationURL))
            } catch {
                completionHandler(.failure(.custom(error.localizedDescription)))
            }
        }.resume()
    }
    
    func execute(
        with urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil,
        attempt: Int,
        completionHandler: @escaping (Result<URL, NetworkError>) -> Void
    ) {
        let request = interceptor?.intercept(urlRequest) ?? urlRequest
        var attempt = attempt
        
        execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName) { [weak self] result in
            repeat {
                switch result {
                case .success(let url):
                    completionHandler(.success(url))
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
    
    func execute(
        with urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil
    ) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName) { result in
                switch result {
                case .success(let url):
                    continuation.resume(returning: url)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func execute(
        with urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil,
        attempt: Int
    ) async throws -> URL {
        var attempt = attempt
        
        repeat {
            do {
                let request = interceptor?.intercept(urlRequest) ?? urlRequest
                let url = try await execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName)
                return url
            } catch {
                guard
                    let retrier = retrier,
                    await retrier.shouldRetryAsync(with: error, attempt: attempt)
                else { throw error }
                
                attempt += 1
            }
        } while true
    }
    
    private func getFilePath(for url: URL, directoryURL: URL?, fileName: String?) -> URL {
        let finalDirectory = directoryURL ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let finalFileName = fileName ?? url.lastPathComponent
        return finalDirectory.appendingPathComponent(finalFileName)
    }
}

extension DownloadRequest {
    
    public func downloadResponse(
        from urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil,
        completionHandler: @escaping (DownloadResponse) -> Void
    ) {
        execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName, attempt: 0) { result in
            switch result {
            case .success(let url):
                completionHandler(.init(url: url, error: nil))
            case .failure(let error):
                completionHandler(.init(url: nil, error: error))
            }
        }
    }
    
    public func downloadResponseAsync(
        from urlRequest: URLRequest,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil
    ) async -> DownloadResponse {
        do {
            let url = try await execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName, attempt: 0)
            
            return .init(url: url, error: nil)
        } catch {
            guard let networkError = error as? NetworkError
            else { return .init(url: nil, error: .custom(error.localizedDescription)) }
            
            return .init(url: nil, error: networkError)
        }
    }
    
    public func downloadResponse(
        from urlRequestBuilder: URLRequestBuilder,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil,
        completionHandler: @escaping (DownloadResponse) -> Void
    ) {
        guard let urlRequest = urlRequestBuilder.build()
        else {
            completionHandler(.init(url: nil, error: .invalidRequest))
            return
        }
        
        execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName, attempt: 0) { result in
            switch result {
            case .success(let url):
                completionHandler(.init(url: url, error: nil))
            case .failure(let error):
                completionHandler(.init(url: nil, error: error))
            }
        }
    }
    
    public func downloadResponseAsync(
        from urlRequestBuilder: URLRequestBuilder,
        toDirectory directoryURL: URL? = nil,
        withFileName fileName: String? = nil
    ) async -> DownloadResponse {
        guard let urlRequest = urlRequestBuilder.build()
        else { return .init(url: nil, error: .invalidRequest) }
        
        do {
            let url = try await execute(with: urlRequest, toDirectory: directoryURL, withFileName: fileName, attempt: 0)
            
            return .init(url: url, error: nil)
        } catch {
            guard let networkError = error as? NetworkError
            else { return .init(url: nil, error: .custom(error.localizedDescription)) }
            
            return .init(url: nil, error: networkError)
        }
    }
}
