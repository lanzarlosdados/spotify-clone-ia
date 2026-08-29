//
//  Endpoint.swift
//  SpotifyCloneIA
//
//  Created by Fabian Zarate on 4/9/25.
//

import Foundation

struct Endpoint {
    let path: String
    let queryParameters: [String : Any]
    let method: HTTPMethod
}
