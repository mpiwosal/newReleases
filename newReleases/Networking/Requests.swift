//
//  Requests.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation

//if you want to perform a follow-up (next) request, pass URL from "next" json field.
extension NetworkingManager {
    public static func performFollowingRequest(url : URL? = nil) {
        
        let finalUrl = url ?? Endpoint.getFollowingEndpoint().url!
        
        genericRequest(url: finalUrl, method: .get)
    }
}
