//
//  NotificationFunctions.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class NotificationFunctions: NSObject {
    
    static func checkBirthdays() {
        let birthdayClients: [ClientModel] = getTodayBirthdayClients()
        let todayNotifications: [NotificationModel] = getTodayNotifications()
        var todayBirthdayClients: [ClientModel] = []
        
        if birthdayClients.count == 0 {
            return
        }
        
        for client in birthdayClients {
            var notificationExists = false
            for notification in todayNotifications {
                if notification.clientId == client.id {
                    notificationExists = true
                }
            }
            
            if !notificationExists {
                todayBirthdayClients.append(client)
            }
        }
        
        var newNotifications: [NotificationModel] = []
        for client: ClientModel in todayBirthdayClients {
            newNotifications.append(createBirthdayNotification(client: client))
        }
        
        if newNotifications.count > 0 {
            print("AÑADIDOS NOTIFICACIONES CUMPLEAÑOS")
            WebServices.addNotifications(notifications: newNotifications)
        }
    }
    
    private static func getTodayBirthdayClients() -> [ClientModel] {
        let clients: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        var birthdayClients: [ClientModel] = []
        let todayDay: Int = Calendar.current.component(.day, from: Date())
        let todayMonth: Int = Calendar.current.component(.month, from: Date())
        
        for client in clients {
            let clientDay: Int = Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(client.fecha)))
            let clientMonth: Int = Calendar.current.component(.month, from: Date(timeIntervalSince1970: TimeInterval(client.fecha)))
            
            if clientDay == todayDay && clientMonth == todayMonth {
                birthdayClients.append(client)
            }
        }
        
        return birthdayClients
    }
    
    private static func getTodayNotifications() -> [NotificationModel] {
        var todayNotifications: [NotificationModel] = []
        
        let notifications: [NotificationModel] = Constants.databaseManager.notificationsManager.getAllNotificationsForType(type: Constants.notificacionCumpleIdentifier)
        let begginingOfDay: Int64 = Int64(getBeginningOfDayFromDate(date: Date()).timeIntervalSince1970)
        let endOfDay: Int64 = Int64(getEndOfDayFromDate(date: Date()).timeIntervalSince1970)
        for notification in notifications {
            if notification.fecha > begginingOfDay && notification.fecha < endOfDay {
                todayNotifications.append(notification)
            }
        }
        
        return todayNotifications
    }
    
    static func getBeginningOfDayFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components)!
    }
    
    static func getEndOfDayFromDate(date: Date) -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        return calendar.date(from: components)!
    }
    
    static func createBirthdayNotification(client: ClientModel) -> NotificationModel {
        let notification: NotificationModel = NotificationModel()
        notification.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        notification.fecha = Int64(Date().timeIntervalSince1970)
        notification.clientId = client.id
        notification.leido = false
        notification.type = Constants.notificacionCumpleIdentifier
        return notification
    }
    
    private static func getUserIdsFromBirthdayModels(users: [BirthdayModel]) -> [Int64] {
        var userIds: [Int64] = []
        for user in users {
            userIds.append(user.userId)
        }
        
        return userIds
    }
    
    private static func getClientIds(clients: [ClientModel]) -> [Int64] {
        var clientIds: [Int64] = []
        for client in clients {
            clientIds.append(client.id)
        }
        
        return clientIds
    }
    
    static func checkCierreCajas() {
        let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let beginingOfDay: Date = AgendaFunctions.getBeginningOfDayFromDate(date: yesterday)
        let endOfDay: Date = AgendaFunctions.getEndOfDayFromDate(date: yesterday)
        
        let cierreCajaExist: Bool = checkCierreCajasInRange(beginingOfDay: beginingOfDay, endOfDay: endOfDay)
        let serviciosExist: Bool = Constants.databaseManager.servicesManager.getServicesForDay(date: yesterday).count > 0
        let notificationExist: Bool = checkCierreCajasNotificationForRange(beginingOfDay: beginingOfDay, endOfDay: endOfDay)
        
        if notificationExist {
            return
        }
        
        var cierreCajaNotifications: [NotificationModel] = []
        if !cierreCajaExist && serviciosExist {
            print("AÑADIDOS NOTIFICACIONES CIERRE CAJA")
            cierreCajaNotifications.append(createCierreCajaNotification(fecha: yesterday))
            WebServices.addNotifications(notifications: cierreCajaNotifications)
        }
    }
    
    private static func createCierreCajaNotification(fecha: Date) -> NotificationModel {
        let notification: NotificationModel = NotificationModel()
        notification.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        notification.fecha = Int64(fecha.timeIntervalSince1970)
        notification.leido = false
        notification.type = Constants.notificacionCajaCierreIdentifier
        return notification
    }
    
    private static func checkCierreCajasInRange(beginingOfDay: Date, endOfDay: Date) -> Bool {
        let begininOfDayTimestamp: Int64 = Int64(beginingOfDay.timeIntervalSince1970)
        let endOfDayTimestamp: Int64 = Int64(endOfDay.timeIntervalSince1970)
        let cierreCajas: [CierreCajaModel] = Constants.databaseManager.cierreCajaManager.getAllCierreCajasFromDatabase()
        
        for cierreCaja in cierreCajas {
            if cierreCaja.fecha > begininOfDayTimestamp && cierreCaja.fecha < endOfDayTimestamp {
                return true
            }
        }
        
        return false
    }
    
    private static func checkCierreCajasNotificationForRange(beginingOfDay: Date, endOfDay: Date) -> Bool {
        let begininOfDayTimestamp: Int64 = Int64(beginingOfDay.timeIntervalSince1970)
        let endOfDayTimestamp: Int64 = Int64(endOfDay.timeIntervalSince1970)
        let cierreCajasNotifications: [NotificationModel] = Constants.databaseManager.notificationsManager.getAllNotificationsForType(type: Constants.notificacionCajaCierreIdentifier)
        
        for notification in cierreCajasNotifications {
            if notification.fecha > begininOfDayTimestamp && notification.fecha < endOfDayTimestamp {
                return true
            }
        }
        
        return false
    }
    
    static func checkClientCadencias() {
        var clientesConCadenciaSuperada: [ClientModel] = []
        let clients: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        let notifications: [NotificationModel] = Constants.databaseManager.notificationsManager.getAllNotificationsForType(type: Constants.notificacionCadenciaIdentifier)
        
        for client in clients {
            let cadencia: CadenciaModel = CadenciaModel(cadencia: client.cadenciaVisita)
            let services = Constants.databaseManager.servicesManager.getServicesForClientId(clientId: client.id)
            
            if aSuperadoCadencia(services: services, cadencia: cadencia, clientId: client.id) {
                if !hasClientANotification(notifications: notifications, clientId: client.id) {
                    clientesConCadenciaSuperada.append(client)
                }
            }
        }
        
        var newNotifications: [NotificationModel] = []
        for cliente: ClientModel in clientesConCadenciaSuperada {
            newNotifications.append(createCadenciaNotification(cliente: cliente))
        }
        
        if newNotifications.count > 0 {
            print("AÑADIDOS NOTIFICACIONES CADENCIA")
            WebServices.addNotifications(notifications: newNotifications)
        }
    }
    
    private static func aSuperadoCadencia(services: [ServiceModel], cadencia: CadenciaModel, clientId: Int64) -> Bool {
        if services.count > 0 {
            for service in services {
                if service.fecha > cadencia.candenciaTime {
                    return false
                }
            }
            
            return true
        } else {
            //si el usuario no tiene servicios, comparamos con la fecha de creación de usuario
            return clientId < cadencia.candenciaTime
        }
    }
    
    private static func hasClientANotification(notifications: [NotificationModel], clientId: Int64) -> Bool {
        var notificationExists = false
        for notification in notifications {
            if notification.clientId == clientId {
                notificationExists = true
            }
        }
        
        return notificationExists
    }
    
    private static func createCadenciaNotification(cliente: ClientModel) -> NotificationModel {
        let notification: NotificationModel = NotificationModel()
        notification.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        notification.fecha = Int64(Date().timeIntervalSince1970)
        notification.clientId = cliente.id
        notification.leido = false
        notification.type = Constants.notificacionCadenciaIdentifier
        
        return notification
    }
    
    static func createNotificacionPersonalizada(fecha: Int64, clientId: Int64, descripcion: String) -> NotificationModel {
        let notification: NotificationModel = NotificationModel()
        notification.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        notification.fecha = fecha
        notification.clientId = clientId
        notification.leido = false
        notification.descripcion = descripcion
        notification.type = Constants.notificacionPersonalizadaIdentifier
        
        return notification
    }
    
    static func checkNotificacionesPersonalizadas() {
        let clientes: [ClientModel] = Constants.databaseManager.clientsManager.getAllClientsFromDatabase()
        let beginingOfDay: Int64 = Int64(AgendaFunctions.getBeginningOfDayFromDate(date: Date()).timeIntervalSince1970)
        let endOfDay: Int64 = Int64(AgendaFunctions.getEndOfDayFromDate(date: Date()).timeIntervalSince1970)
        
        var notificaciones: [NotificationModel] = []
        for cliente in clientes {
            if cliente.fechaNotificacionPersonalizada > beginingOfDay && cliente.fechaNotificacionPersonalizada < endOfDay && !existsNotificacionPersonalizada(clientId: cliente.id) {
                let notificacion: NotificationModel = createNotificacionPersonalizada(fecha: cliente.fechaNotificacionPersonalizada, clientId: cliente.id, descripcion: cliente.observaciones)
                notificaciones.append(notificacion)
            }
        }
        
        if notificaciones.count > 0 {
            print("AÑADIDOS NOTIFICACIONES PERSONALIZADAS")
            WebServices.addNotifications(notifications: notificaciones)
        }
    }
    
    private static func existsNotificacionPersonalizada(clientId: Int64) -> Bool {
        let notificaciones: [NotificationModel] = Constants.databaseManager.notificationsManager.getAllNotificationsForType(type: Constants.notificacionPersonalizadaIdentifier)
        for notificacion in notificaciones {
            if notificacion.clientId == clientId {
                return true
            }
        }
        
        return false
    }
    
    static func checkAllNotifications() {
        NotificationFunctions.checkBirthdays()
        NotificationFunctions.checkCierreCajas()
        NotificationFunctions.checkClientCadencias()
        NotificationFunctions.checkNotificacionesPersonalizadas()
        Constants.databaseManager.notificationsManager.deleteOldNotifications()
    }
}
