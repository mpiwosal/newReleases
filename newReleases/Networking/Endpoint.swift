//
//  Endpoint.swift
//  newReleases
//
//  Created by Marcin Piwoński on 07/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation


struct Endpoint {

    struct Constants {
        static let scheme = "https"
        static let client_id = "cf640cf876ac4763aab8b3fe21d5ecfd"
        //add additional scopes separating them by spaces (check if it is properly encoded), or "+"
        static let scopes = "user-follow-read"
        static let redirect_uri = "newReleases://authCallback"
    }
    
    enum Host : String {
        case heroku = "newreleasesapp.herokuapp.com"
        case spotifyAuth = "accounts.spotify.com"
        case spotifyApi = "api.spotify.com"
    }
    
    let path : String
    let queryItems : [URLQueryItem]?
    let host : Host

    
    var url : URL? {
        
        var components = URLComponents()
        components.host = host.rawValue
        components.scheme = "https"
        components.queryItems = queryItems
        components.path = path
        
        return components.url
    }
    
    init(host : Host, path : String, queryItems : [URLQueryItem]? = nil){
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}


extension Endpoint {
//    static func authenticate(with bla : String) -> Endpoint {
//        return Endpoint(host: .heroku, path: "/path/to/authenticate")
//    }
    
    static func getAuthorizationCodeEndpoint() -> Endpoint {
        return Endpoint(host: .spotifyAuth, path: "/authorize",
                        queryItems:
                        [
                                URLQueryItem(name: "client_id", value: Constants.client_id),
                                URLQueryItem(name: "response_type", value: "code"),
                                URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri),
                                URLQueryItem(name: "scope", value: Constants.scopes)
                        ]
        )
    }
    
    static func getAccessTokenEndpoint() -> Endpoint {
        return Endpoint(host: .heroku, path: "/api/token")
    }
    
    
    // GET FOLLOWED ARTISTS
    // GET https://api.spotify.com/v1/me/following
    // REQUIRES user-follow-modify
    static func getFollowingEndpoint() -> Endpoint{
        return Endpoint(host: .spotifyApi, path: "/v1/me/following",
                        queryItems:
                        [
                            URLQueryItem(name: "type", value: "artist"),
                            URLQueryItem(name: "limit", value: "20")
                        ])
    }
    
}
