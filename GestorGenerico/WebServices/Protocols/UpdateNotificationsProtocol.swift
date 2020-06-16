//
//  UpdateNotificationsProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 16/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol UpdateNotificationsProtocol {
    func successUpdatingNotifications(notifications: [NotificationModel])
    func errorUpdatingNotifications()
    func logoutResponse()
}
