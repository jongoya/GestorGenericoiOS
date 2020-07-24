//
//  VentaModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class VentaModel: Codable {
    var cestaId:Int64 = 0
    var ventaId: Int64 = 0
    var productoId: Int64 = 0
    var cantidad: Int = 1
    var comercioId: Int64 = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
    
    init(productoId: Int64) {
        self.productoId = productoId
    }
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case cestaId = "cestaId"
        case ventaId = "ventaId"
        case productoId = "productoId"
        case cantidad = "cantidad"
        case comercioId = "comercioId"
    }
}

extension VentaModel {
    func createJson() -> [String: Any] {
        return ["cestaId" : cestaId, "ventaId" : ventaId, "productoId" : productoId, "cantidad" : cantidad, "comercioId" : comercioId]
    }
}
