//
//  HTTPClientError.swift
//  SpotifyCloneIA
//
//  Created by Fabian Zarate on 4/9/25.
//

import Foundation

enum HTTPClientError: Error {
    case clientError
    case serverError
    case generic
    case parsingError
    case badURL
    case responseError
    case tooManyRequests
}
