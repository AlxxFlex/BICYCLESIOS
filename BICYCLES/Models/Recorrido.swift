//
//  Recorrido.swift
//  BICYCLES
//
//  Created by Aaron Alejandro Martinez Solis on 29/03/25.
//

import Foundation

struct Recorrido: Codable {
    let id: String
    let bicicletaNombre: String
    let calorias: Int
    let tiempo: String
    let velocidadPromedio: Double
    let velocidadMaxima: Int
    let distanciaRecorrida: Double
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case bicicletaNombre = "bicicleta_nombre"
        case calorias
        case tiempo
        case velocidadPromedio = "velocidad_promedio"
        case velocidadMaxima = "velocidad_maxima"
        case distanciaRecorrida = "distancia_recorrida"
        case createdAt = "created_at"
    }
}
