//
//  NotificationDayModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 16/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class NotificationDayModel {
    var fecha: Int64 = 0
    var notificaciones: [NotificationModel] = []
    
    init(fecha: Int64, notificaciones: [NotificationModel]) {
        self.fecha = fecha
        self.notificaciones = notificaciones
    }
}
