//
//  RequestBuilder.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation

enum HTTPMethod : String{
    case get = "GET"
    case post = "POST"
}

struct RequestBuilder {
    var endpoint : Endpoint
    var httpMethod : HTTPMethod
    var code : String?
    
    typealias Params = [String : String]
    
    var params : Params?
    
    init(endpoint : Endpoint, httpMethod : HTTPMethod, params : Params? = nil, code : String? = nil) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.params = params
        self.code = code
    }
    
    
    private var request : URLRequest {
        get{
            var request = URLRequest(url: endpoint.url!)
            request.httpMethod = httpMethod.rawValue
            return request
        }
    }
}

extension RequestBuilder {

    
    
    public static func getAuthorizationCodeRequest() -> URLRequest {
        let requestBuilder = RequestBuilder(endpoint: Endpoint.getAuthorizationCodeEndpoint(), httpMethod: .get)
        return requestBuilder.request
    }
    
    public static func getAccessTokenRequest(fromCode code : String) -> URLRequest {
        let requestBuilder = RequestBuilder(endpoint: Endpoint.getAccessTokenFromCodeEndpoint(code), httpMethod: .post, code: code)
        return requestBuilder.request
    }
}
