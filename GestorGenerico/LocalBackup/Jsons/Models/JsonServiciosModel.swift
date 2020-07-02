//
//  JsonServiciosModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 30/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class JsonServiciosModel: Codable {
    var clientId: Int64 = 0
    var serviceId: Int64 = 0
    var fecha: Int64 = 0
    var profesional: Int64 = 0
    var servicio: [Int64] = []
    var observacion: String = ""
    var precio: Double = 0.0
}
