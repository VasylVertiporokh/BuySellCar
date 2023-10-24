//
//  EndpointBuilderProtocol.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.02.2023.
//

import Foundation

protocol EndpointBuilderProtocol {
    var baseURL: URL? { get }
    var path: String { get }
    var query: [String: String]? { get }
    var headerFields: [String: String] { get }
    var body: RequestBody? { get }
    var method: HTTPMethod { get }
}

extension EndpointBuilderProtocol {
    var headerFields: [String: String] {
        return [:]
    }
}

// MARK: - Internal extension
extension EndpointBuilderProtocol {
    var baseURL: URL? { nil }
    var query: [String: String]? { nil }
    var body: RequestBody? { nil }
    
    func createRequest(_ baseUrl: URL, _ encoder: JSONEncoder, _ plugins: [NetworkPlugin]) throws -> URLRequest {
        var request: URLRequest
        do {
            request = .init(url: try buildUrl(self.baseURL ?? baseUrl))
        } catch {
            throw error
        }
        request.httpMethod = method.rawValue
        headerFields.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        plugins.forEach { $0.modifyRequest(&request) }
        
        guard let body = body else {
            NetworkLogger.log(request)
            return request
        }
        
        switch body {
        case .rawData(let data):
            request.httpBody = data
            
        case .encodable(let encodable):
            guard let data = try? encoder.encode(encodable) else {
                throw RequestBuilderError.bodyEncodingError
            }
            request.httpBody = data
            
        case .multipartBody(let items):
            let multipartBody = buildMultipartBody(items: items)
            request.httpBody = multipartBody.multipartData
            request.setValue("multipart/form-data; boundary=\(multipartBody.boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("\(multipartBody.length)", forHTTPHeaderField: "Content-Length")
        }
        NetworkLogger.log(request)
        return request
    }
}

// MARK: - Private extension
private extension EndpointBuilderProtocol {
    func buildUrl(_ baseURL: URL) throws -> URL {
        let url = baseURL.appendingPathComponent(path)
        guard let query = query else {
            return url
        }
        
        guard var components = URLComponents(string: url.absoluteString) else {
            throw RequestBuilderError.badURL
        }
        components.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            throw RequestBuilderError.badURLComponents
        }
        return url
    }
    
    func buildMultipartBody(items: [MultipartItem]) -> MultipartBody {
        let requestBody = NSMutableData()
        let boundary: String = UUID().uuidString
        let lineBreak = "\r\n"
        
        for item in items {
            requestBody.append("\(lineBreak)--\(boundary + lineBreak)")
            requestBody.append("Content-Disposition: form-data; name=\"\(item.attachmentKey)\"")
            requestBody.append("; filename=\"\(item.fileName)\"\(lineBreak)")
            requestBody.append("Content-Type: \(item.mimeType.rawValue) \(lineBreak + lineBreak)")
            requestBody.append(item.data)
        }
        requestBody.append("\(lineBreak)--\(boundary)--\(lineBreak)")
        return .init(boundary: boundary, multipartData: requestBody as Data, length: requestBody.count)
    }
}

// MARK: - NSMutableData + Append String
fileprivate extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
