//
//  ClientMasServicios.swift
//  GestorGenerico
//
//  Created by jon mikel on 12/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class ClientMasServicios: Codable {
    var cliente: ClientModel!
    var servicios: [ServiceModel] = []
    
    init(cliente: ClientModel, servicios: [ServiceModel]) {
        self.cliente = cliente
        self.servicios = servicios
    }
    
    private enum CodingKeys: String, CodingKey {
        case cliente = "cliente"
        case servicios = "servicios"
    }
}

extension ClientMasServicios {
    func createJson() -> [String : Any] {
        var json: [String : Any] = [:]
        json["cliente"] = cliente.createClientJson()
        var servicios: [[String: Any]] = []
        for servicio : ServiceModel in self.servicios {
            servicios.append(servicio.createJson())
        }
        
        json["servicios"] = servicios
        
        return json
    }
}
