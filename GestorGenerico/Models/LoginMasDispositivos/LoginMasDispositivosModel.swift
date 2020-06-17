//
//  LoginMasDispositivosModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 10/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class LoginMasDispositivosModel: Codable {
    var login: LoginModel!
    var dispositivos: [DispositivoModel] = []
    var estiloApp: EstiloAppModel!
    
    init() {
    }
    
    init(login: LoginModel, dispositivos: [DispositivoModel]) {
        self.login = login
        self.dispositivos = dispositivos
    }
    
    private enum CodingKeys: String, CodingKey {
        case login = "login"
        case dispositivos = "dispositivos"
        case estiloApp = "estiloPrivado"
    }
}

extension LoginMasDispositivosModel {
    func createJsonForLogin() -> [String : Any]{
        var json: [String : Any] = [:]
        json["login"] = login.createJsonForLogin()
        
        var arrayDispositivos: [[String : Any]] = []
        for dispositivo: DispositivoModel in dispositivos {
            arrayDispositivos.append(dispositivo.createJsonFromModel())
        }
        json["dispositivos"] = arrayDispositivos
        
        return json
    }
}
