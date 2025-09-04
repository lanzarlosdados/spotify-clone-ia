//
//  HTTPCLient.swift
//  SpotifyCloneIA
//
//  Created by Fabian Zarate on 4/9/25.
//

import Foundation

protocol HTTPCLient {
    func makeRequest(endpoint: Endpoint, baseUrl: String) async -> Result<Data, HTTPClientError>
}
