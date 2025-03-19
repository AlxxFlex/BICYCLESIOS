//
//  User.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 10/03/25.
//

import Foundation

struct User: Codable {
    let id: Int?
    let nombre: String
    let apellido: String
    let peso: Float
    let estatura: Float
    let email: String
    let rol_id: Int?
    let email_verified_at: String?
    let deleted_at: String?
}
