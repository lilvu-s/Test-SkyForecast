//
//  Routes.swift
//  SkyForecast
//
//  Created by Angelina on 16.12.2023.
//  Copyright © 2023 HellySolovii. All rights reserved.
//

import Foundation

public struct Route {
    private let baseURL: String
    public let path: String
    public let method: String
    public let parameters: [String: String]
    public let headers: [String: String]?
    public var httpBody: Data?

    public init(
        baseURL: String,
        path: String,
        method: String,
        parameters: [String: String],
        headers: [String: String]? = nil,
        httpBody: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.httpBody = httpBody
    }

    public func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: baseURL + path) ?? URLComponents()
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpBody = httpBody
        
        return urlRequest
    }
}
