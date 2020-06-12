//
//  ClientModel.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ClientModel: Codable {
    var id: Int64 = 0
    var nombre: String = ""
    var apellidos: String = ""
    var fecha: Int64 = 0
    var telefono: String = ""
    var email: String = ""
    var direccion: String = ""
    var cadenciaVisita: String = ""
    var observaciones: String = ""
    var fechaNotificacionPersonalizada: Int64 = 0
    var imagen: String = ""
    var comercioId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case nombre = "nombre"
        case apellidos = "apellidos"
        case fecha = "fecha"
        case telefono = "telefono"
        case email = "email"
        case direccion = "direccion"
        case cadenciaVisita = "cadenciaVisita"
        case observaciones = "observaciones"
        case fechaNotificacionPersonalizada = "fechaNotificacionPersonalizada"
        case imagen = "imagen"
        case comercioId = "comercioId"
    }
}

extension ClientModel {
    func createClientJson() -> [String : Any]{
        return ["id" : id, "nombre" : nombre, "apellidos" : apellidos, "fecha" : fecha, "telefono" : telefono, "email" : email, "direccion" : direccion, "cadenciaVisita" : cadenciaVisita, "observaciones" : observaciones, "fechaNotificacionPersonalizada" : fechaNotificacionPersonalizada, "imagen" : imagen, "comercioId" : comercioId]
    }
}
