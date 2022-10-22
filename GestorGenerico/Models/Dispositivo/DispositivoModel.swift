//
//  DispositivoModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 10/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class DispositivoModel: Codable {
    var dispositivoId: Int64 = 0
    var comercioId: Int64 = 0
    var fecha: Int64 = 0
    var nombre_dispositivo: String = ""
    var unique_deviceId: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case dispositivoId = "dispositivoId"
        case comercioId = "comercioId"
        case fecha = "fecha"
        case nombre_dispositivo = "nombre_dispositivo"
        case unique_deviceId = "unique_deviceId"
    }
}

extension DispositivoModel {
    func createJsonFromModel() -> [String: Any]{
        return ["dispositivoId" : self.dispositivoId, "comercioId" : self.comercioId, "fecha" : self.fecha, "nombre_dispositivo" : self.nombre_dispositivo, "unique_deviceId" : self.unique_deviceId]
    }
}
