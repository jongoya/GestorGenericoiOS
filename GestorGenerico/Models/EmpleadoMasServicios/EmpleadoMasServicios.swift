//
//  EmpleadoMasServicios.swift
//  GestorGenerico
//
//  Created by jon mikel on 12/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class EmpleadoMasServicios: Codable {
    var empleado: EmpleadoModel!
    var servicios: [ServiceModel] = []
    
    private enum CodingKeys: String, CodingKey {
        case empleado = "empleado"
        case servicios = "servicios"
    }
}

extension EmpleadoMasServicios {
    func createJson() -> [String : Any] {
        var json: [String : Any] = [:]
        json["empleado"] = empleado.createJson()
        var servicios: [[String: Any]] = []
        for servicio : ServiceModel in self.servicios {
            servicios.append(servicio.createJson())
        }
        
        json["servicios"] = servicios
        
        return json
    }
}
