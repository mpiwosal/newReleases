//
//  NetworkingManager.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation
import AuthenticationServices
import Alamofire

struct AuthResult : Codable {
    var accessToken : String?
    var refreshToken : String?
}

extension AuthResult {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

protocol NetworkingManagerDelegate {
    func authorizationEndedWithError(_ error: Error)
    func authorizedSuccessfully()
}

struct NetworkingManager {
    static var delegate : NetworkingManagerDelegate?
    static var accessToken : String?
    static var refreshToken : String?
    static var accessTokenHeader : HTTPHeader? {
        guard let accessToken = accessToken else {
            return nil
        }
       
        return HTTPHeader(name: "Authorization", value: "Bearer \(accessToken)")
    }

}


// Authentication
extension NetworkingManager {
    
    static var authenticationSession : ASWebAuthenticationSession?
    
    
    static func performAuthentication(){
        self.getAuthorizationCode(){
            code in
            self.getAccessToken(fromCode : code)
        }
    }
    
    private static func getAuthorizationCode(completionHandler: @escaping (String) -> Void){
        self.authenticationSession = ASWebAuthenticationSession(url: Endpoint.getAuthorizationCodeEndpoint().url!, callbackURLScheme: nil){
            url, error in
            if let error = error {
                delegate?.authorizationEndedWithError(error)
                return
            }
            
            guard let code = url?.getValueOfQueryItem(withName: "code") else {
            
                delegate?.authorizationEndedWithError(ASWebAuthenticationSessionError.init(_nsError: NSError(domain: "Undefined Error", code: 0, userInfo: nil)))
                return
            }
            
            completionHandler(code)
            
        }
        self.authenticationSession?.start()
    }
    
    private static func getAccessToken(fromCode code: String){
        let parameters = ["code" : code]
        
        
        AF.request(Endpoint.getAccessTokenEndpoint().url!, method: .post, parameters: parameters).responseJSON {
            response in
            switch response.result {
            case .success:
                // if, for some reason, data is nil despite response.result being success,
                // fallthrough to case .failure
                guard let data = response.data else {
                    fallthrough
                }
                let authResult = try! JSONDecoder().decode(AuthResult.self, from: data)
                accessToken = authResult.accessToken
                refreshToken = authResult.refreshToken
                delegate?.authorizedSuccessfully()
            case .failure:
                print("failed")
            }
            
        }
    }
}

//general requests
extension NetworkingManager {
    static func request(endpoint : Endpoint, method : HTTPMethod = .get, parameters: Parameters? = nil, headers : HTTPHeaders? = nil){
        
        var allHeaders = HTTPHeaders()
        if let headers = headers {
            allHeaders = headers
        }
        allHeaders.add(self.accessTokenHeader!)
        
        AF.request(endpoint.url!, method: method, parameters: parameters, headers: allHeaders).validate().responseJSON{
            response in
            switch (response.result){
            case .success:
                print(response.value)
            case .failure:
                if (response.response?.statusCode == 429){
                    print("access token expired")
                    //perform refresh token logic
                }
                print("\(String(describing: response.error))")
            }
        }
    }
}

