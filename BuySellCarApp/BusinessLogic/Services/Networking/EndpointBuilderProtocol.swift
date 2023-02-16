//
//  EndpointBuilderProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

protocol EndpointBuilderProtocol {
    var path: String { get }
    var query: [String: String]? { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
    var baseURL: URL? { get }
    var headerFields: [String: String] { get }
}

// MARK: - Internal extension
extension EndpointBuilderProtocol {
    var appId: String? { nil }
    var apiKey: String? { nil }
    var baseURL: URL? { nil }
    var query: [String: String]? { nil }
    var body: Data? { nil }
    
    func createRequest(baseUrl: URL) -> URLRequest {
        var request = URLRequest(url: self.baseURL ?? buldUrl(baseURL: baseUrl))
        headerFields.forEach {
            request.addValue(
                $0.key,
                forHTTPHeaderField: $0.value
            )
        }
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}

// MARK: - Private extension
private extension EndpointBuilderProtocol {
    func buldUrl(baseURL: URL) -> URL {
        let url = baseURL.appendingPathComponent(path)
    
        guard let query = query else {
            print(Constants.withoutQueryItemMassage + url.absoluteString)
            return url
        }
        
        guard var components = URLComponents(string: url.absoluteString) else {
            fatalError(Constants.incorrectPath + url.absoluteString)
        }
        
        components.queryItems = query.map {
            URLQueryItem(
                name: $0.key,
                value: $0.value
            )
        }
        
        guard let url = components.url else {
            fatalError(Constants.incorrectPathWithQueryItems)
        }
        return url
    }
    
    func modelToData<M: Encodable>(_ model: M) -> Data? {
        return try? JSONEncoder().encode(model)
    }
}

// MARK: - Constants
private struct Constants {
    static let emptyString: String = ""
    static let incorrectPath: String = "Path is incorrect"
    static let withoutQueryItemMassage: String = "🟡 Request without QueryItems ---> \n"
    static let incorrectPathWithQueryItems: String = "❌ URL with path and query items is incorrect"
}
