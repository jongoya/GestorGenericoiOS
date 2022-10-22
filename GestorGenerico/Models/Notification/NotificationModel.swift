//
//  NotificationModel.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class NotificationModel: Codable {
    var clientId: Int64 = 0
    var notificationId: Int64 = 0
    var descripcion: String = ""
    var fecha: Int64 = 0
    var leido: Bool = false
    var type: String = ""
    var comercioId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "clientId"
        case notificationId = "notificationId"
        case descripcion = "descripcion"
        case fecha = "fecha"
        case leido = "leido"
        case type = "type"
        case comercioId = "comercioId"
    }
}

extension NotificationModel {
    func createJson() -> [String : Any] {
        return ["clientId" : clientId, "notificationId" : notificationId, "descripcion" : descripcion, "fecha" : fecha, "leido" : leido, "type" : type, "comercioId" : comercioId]
    }
}
