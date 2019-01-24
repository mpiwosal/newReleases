//
//  ArtistsViewController.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import UIKit

class ArtistsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.backgroundColor = UIColor.green.cgColor
        NetworkingManager.performFollowingRequest()
        // Do any additional setup after loading the view.
    }
    

}
