//
//  RegisterResponse.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 16/03/25.
//

import Foundation

struct RegisterResponse: Codable {
    let mensaje: String?
    let usuario: User
}
