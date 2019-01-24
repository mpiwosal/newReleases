//
//  NetworkingManager.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation
import AuthenticationServices

enum Result<String> {
    case success
    case failure(String)
}


struct NetworkingManager {
    static var authenticationSession : ASWebAuthenticationSession?
    static var urlSession = URLSession.shared
    static var accessToken : String?
    
    static func performAuthentication(){
        self.getAuthorizationCode(){
            result in
            self.getAccessToken(fromCode : result)
        }
    }
    
    private static func getAuthorizationCode(completionHandler: @escaping (String) -> Void){
        self.authenticationSession = ASWebAuthenticationSession(url: Endpoint.getAuthorizationCodeEndpoint().url!, callbackURLScheme: nil){
            url, error in
            guard error == nil else{
//                  present error
//                if !((error as! ASWebAuthenticationSessionError).code == ASWebAuthenticationSessionError.canceledLogin) {
//                    self.presentAlertWithError(error!)
//                }
                print(error!)
                return
            }
            
            guard let code = url?.getValueOfQueryItem(withName: "code") else {
                //present error somehow
                return
            }
            
            completionHandler(code)
            
        }
        self.authenticationSession?.start()
    }
    private static func getAccessToken(fromCode code : String){
        let request = RequestBuilder.getAccessTokenRequest(fromCode: code)
        
        let dataTask = urlSession.dataTask(with: request){
            data, response, error in
            print("data: \(data) \n response: \(response) \n error: \(error)")
        }
        dataTask.resume()
        
    }
}
