//
//  CestaMasVentas.swift
//  GestorGenerico
//
//  Created by jon mikel on 23/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class CestaMasVentas: Codable {
    var cesta: CestaModel!
    var ventas: [VentaModel] = []
    
    init(cesta: CestaModel, ventas: [VentaModel]) {
        self.cesta = cesta
        self.ventas = ventas
    }
    
    private enum CodingKeys: String, CodingKey {
        case cesta = "cesta"
        case ventas = "ventas"
    }
}

extension CestaMasVentas {
    func createJson() -> [String : Any] {
        var json: [String : Any] = [:]
        json["cesta"] = cesta.createJson()
        var ventas: [[String: Any]] = []
        for venta : VentaModel in self.ventas {
            ventas.append(venta.createJson())
        }
        
        json["ventas"] = ventas
        
        return json
    }
}
