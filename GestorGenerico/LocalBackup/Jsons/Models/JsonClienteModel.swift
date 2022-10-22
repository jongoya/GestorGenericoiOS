//
//  JsonClienteModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 30/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class JsonClienteModel: Codable {
    var id: Int64 = 0
    var nombre: String = ""
    var apellidos: String = ""
    var fecha: Int64 = 0
    var telefono: String = ""
    var email: String = ""
    var direccion: String = ""
    var cadenciaVisita: String = "cada 2 semanas"
    var observaciones: String = ""
    var notificacionPersonalizada: Int64 = 0
    var imagen: String = ""
}
