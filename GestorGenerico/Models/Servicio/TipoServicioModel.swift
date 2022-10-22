//
//  ServicioModel.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class TipoServicioModel: Codable {
    var nombre: String = ""
    var servicioId: Int64 = 0
    var comercioId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case nombre = "nombre"
        case servicioId = "servicioId"
        case comercioId = "comercioId"
    }
}

extension TipoServicioModel {
    func createJson() -> [String : Any] {
        return ["nombre" : nombre, "servicioId" : servicioId, "comercioId" : comercioId]
    }
    
}
