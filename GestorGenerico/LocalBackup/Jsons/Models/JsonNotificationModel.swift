//
//  JsonNotificationModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 30/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class JsonNotificationModel: Codable {
    var clientId: [Int64] = []
    var notificationId: Int64 = 0
    var descripcion: String = ""
    var fecha: Int64 = 0
    var leido: Bool = false
    var type: String = ""
}
