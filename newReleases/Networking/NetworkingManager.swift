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

protocol AuthorizationErrorDelegate {
    func authorizationEndedWithError(_ error: Error)
}

struct NetworkingManager {
    static var authorizationErrorDelegate : AuthorizationErrorDelegate?
    static var accessToken : String?
    static var refreshToken : String?

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
                authorizationErrorDelegate?.authorizationEndedWithError(error)
                return
            }
            
            guard let code = url?.getValueOfQueryItem(withName: "code") else {
            
                authorizationErrorDelegate?.authorizationEndedWithError(ASWebAuthenticationSessionError.init(_nsError: NSError(domain: "Undefined Error", code: 0, userInfo: nil)))
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
                print(authResult)
            case .failure:
                print("failed")
            }
            
        }
    }
}
