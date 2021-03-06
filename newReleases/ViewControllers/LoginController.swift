//
//  ViewController.swift
//  newReleases
//
//  Created by Marcin Piwoński on 07/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.delegate = self

    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        NetworkingManager.performAuthentication()
    }
    
}

extension LoginController : NetworkingManagerDelegate {
    
    func authorizationEndedWithError(_ error: Error) {
         //                  present error
        if !((error as! ASWebAuthenticationSessionError).code == ASWebAuthenticationSessionError.canceledLogin) {
            self.presentAlertWithError(error)
        }
    }
    
    func authorizedSuccessfully() {
        let artistsVC = ArtistsViewController()
        self.present(artistsVC, animated: true, completion: nil)
    }
    
    func presentAlertWithError(_ error: Error){
        let alert = UIAlertController(title: "Could not login", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}

