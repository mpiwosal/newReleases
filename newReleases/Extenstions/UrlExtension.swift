//
//  UrlExtension.swift
//  newReleases
//
//  Created by Marcin Piwoński on 24/01/2019.
//  Copyright © 2019 Marcin Piwoński. All rights reserved.
//

import Foundation

extension URL {
    func getValueOfQueryItem(withName name: String) -> String? {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == name })?.value
    }
}
