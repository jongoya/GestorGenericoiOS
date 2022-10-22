//
//  ServiceModel.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class ServiceModel: Codable {
    var clientId: Int64 = 0
    var serviceId: Int64 = 0
    var fecha: Int64 = 0
    var empleadoId: Int64 = 0
    var servicios: [Int64] = []
    var observaciones: String = ""
    var precio: Double = 0.0
    var comercioId: Int64 = 0
    var isEfectivo: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "clientId"
        case serviceId = "serviceId"
        case fecha = "fecha"
        case empleadoId = "empleadoId"
        case servicios = "servicios"
        case observaciones = "observacion"
        case precio = "precio"
        case comercioId = "comercioId"
        case isEfectivo = "efectivo"
    }
}

extension ServiceModel {
    func createJson() -> [String : Any] {
        return ["clientId" : clientId, "serviceId" : serviceId, "fecha" : fecha, "empleadoId" : empleadoId, "servicios" : servicios, "observacion" : observaciones, "precio" : precio, "comercioId" : comercioId, "efectivo" : isEfectivo]
    }
}
