//
//  AuthResponse.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 10/03/25.
//

import Foundation

struct AuthResponse: Codable {
    let token: String
    let message: String?
    let user: User
}
