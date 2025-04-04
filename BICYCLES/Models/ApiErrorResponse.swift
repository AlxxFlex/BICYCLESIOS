//
//  ApiErrorResponse.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 10/03/25.
//

import Foundation

struct ApiErrorResponse: Codable {
    let mensaje: String?         
    let errores: [String: [String]]?
    
    let redirect: String?  
    let email: String?
}
