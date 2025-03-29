//
//  RecorridoResponse.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import Foundation
struct RecorridoResponse: Codable {
    let message: String
    let recorridos: [Recorrido]
}
