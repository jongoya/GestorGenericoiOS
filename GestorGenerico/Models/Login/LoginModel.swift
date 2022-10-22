//
//  LoginModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class LoginModel: Codable {
    var comercioId: Int64 = 0
    var usuario: String = ""
    var password: String = ""
    var token: String = ""
    var nombre: String = ""
    var nombre_dispositivo: String?
    var unique_deviceId: String?
    
    init(usuario: String, password: String, nombre: String, nombreDispositivo: String, uniqueDeviceId: String) {
        self.usuario = usuario
        self.nombre = nombre
        self.password = password
        self.nombre_dispositivo = nombreDispositivo
        self.unique_deviceId = uniqueDeviceId
    }
    
    private enum CodingKeys: String, CodingKey {
        case comercioId = "comercioId"
        case usuario = "usuario"
        case password = "password"
        case token = "token"
        case nombre = "nombre"
        case nombre_dispositivo = "nombre_dispositivo"
        case unique_deviceId = "unique_deviceId"
    }
}

extension LoginModel {
    func createJsonForLogin() -> [String: Any] {
        return ["usuario" : self.usuario, "password" : self.password, "nombre_dispositivo" : self.nombre_dispositivo ?? "", "unique_deviceId" : self.unique_deviceId ?? "", "nombre" : self.nombre]
    }
}
