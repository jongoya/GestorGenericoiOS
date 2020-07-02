//
//  JsonEmpleadoModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 30/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class JsonEmpleadoModel: Codable {
    var nombre: String = ""
    var apellidos: String = ""
    var fecha: Int64 = 0
    var telefono: String = ""
    var email: String = ""
    var empleadoId: Int64 = 0
    var redColorValue: Float = 0
    var greenColorValue: Float = 0
    var blueColorValue: Float = 0
}
