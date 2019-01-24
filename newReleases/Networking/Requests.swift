//
//  Requests.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation

extension NetworkingManager {
    public static func performFollowingRequest() {
        request(endpoint: Endpoint.getFollowingEndpoint(), method: .get)
    }
}
