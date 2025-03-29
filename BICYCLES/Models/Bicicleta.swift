//
//  Bicicleta.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    let mensaje: String
    let data: T
}


struct Bicicleta: Codable, Hashable {
    let id: Int
    let nombre: String
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Bicicleta, rhs: Bicicleta) -> Bool {
        return lhs.id == rhs.id
    }
}
