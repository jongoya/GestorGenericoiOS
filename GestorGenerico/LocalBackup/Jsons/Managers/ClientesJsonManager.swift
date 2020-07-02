//
//  ClientesJsonManager.swift
//  GestorHeme
//
//  Created by jon mikel on 27/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import Alamofire

struct JsonModel: Codable {
    var Empleados: [JsonEmpleadoModel]!
    var Clientes: [JsonClienteModel]!
    var Servicios: [JsonServiciosModel]!
    var TipoServicios: [JsonTipoServicioModel]!
    var Notificaciones: [JsonNotificationModel]!
    var CierreCajas: [JsonCierreCajaModel]!
}

class ClientesJsonManager {
    static func parseClientesHeme() {
        do {
            if let path = Bundle.main.path(forResource: "backupHeme", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json: JsonModel = try! JSONDecoder().decode(JsonModel.self, from: data)
                collectValuesFromModel(model: json)
            }
        } catch {
           print("Error parsing json")
        }
    }
    
    private static func collectValuesFromModel(model: JsonModel) {
        let empleados: [EmpleadoModel] = convertEmpleadoJsonsToEmpleadoModels(empleadoJsons: model.Empleados)
        let tipoServicios: [TipoServicioModel] = convertTipoServiciosJsonToTipoServiciosModels(tipoServiciosJson: model.TipoServicios)
        let clientes: [ClientModel] = convertClientesJsonToClientesModel(clientesJson: model.Clientes)
        let servicios: [ServiceModel] = convertServiciosJsonToServiciosModel(serviciosJson: model.Servicios)
        let notificaciones: [NotificationModel] = convertNotificationsJsonToNotificationModels(notiJsons: model.Notificaciones)
        let cierreCajas: [CierreCajaModel] = convertJsonCierreCajasToCierreCajasModel(cierreCajasJson: model.CierreCajas)
        saveEmpleadosInServer(empleados: empleados, tipoServicios: tipoServicios,clientes: clientes, servicios: servicios, notificaciones: notificaciones)
        saveCierreDeCajasInServer(cierreCajas: cierreCajas)
    }
    
    private static func convertEmpleadoJsonsToEmpleadoModels(empleadoJsons: [JsonEmpleadoModel]) -> [EmpleadoModel] {
        var empleados: [EmpleadoModel] = []
        
        for empleadoJson: JsonEmpleadoModel in empleadoJsons {
            let empleado: EmpleadoModel = EmpleadoModel()
            empleado.nombre = empleadoJson.nombre
            empleado.apellidos = empleadoJson.apellidos
            empleado.fecha = empleadoJson.fecha
            empleado.telefono = empleadoJson.telefono
            empleado.email = empleadoJson.email
            empleado.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
            empleado.is_empleado_jefe = empleado.nombre == "Erregue" ? true : false
            empleado.blueColorValue = empleadoJson.blueColorValue * 255
            empleado.greenColorValue = empleadoJson.greenColorValue * 255
            empleado.redColorValue = empleadoJson.redColorValue * 255
            empleado.empleadoId = empleadoJson.empleadoId
            
            empleados.append(empleado)
        }
    
        return empleados
    }
    
    private static func convertTipoServiciosJsonToTipoServiciosModels(tipoServiciosJson: [JsonTipoServicioModel]) -> [TipoServicioModel] {
        var tipoServicios: [TipoServicioModel] = []
        
        for tipoServicioJson: JsonTipoServicioModel in tipoServiciosJson {
            let tipoServicio: TipoServicioModel = TipoServicioModel()
            tipoServicio.nombre = tipoServicioJson.nombre
            tipoServicio.servicioId = tipoServicioJson.servicioId
            tipoServicio.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
            
            tipoServicios.append(tipoServicio)
        }
        
        return tipoServicios
    }
    
    private static func convertClientesJsonToClientesModel(clientesJson: [JsonClienteModel]) -> [ClientModel] {
        var clientes: [ClientModel] = []
        
        for clienteJson: JsonClienteModel in clientesJson {
            let cliente: ClientModel = ClientModel()
            cliente.id = clienteJson.id
            cliente.nombre = clienteJson.nombre
            cliente.apellidos = clienteJson.apellidos
            cliente.fecha = clienteJson.fecha
            cliente.telefono = clienteJson.telefono
            cliente.email = clienteJson.email
            cliente.direccion = clienteJson.direccion
            cliente.cadenciaVisita = clienteJson.cadenciaVisita
            cliente.observaciones = clienteJson.observaciones
            cliente.imagen = clienteJson.imagen
            cliente.fechaNotificacionPersonalizada = clienteJson.notificacionPersonalizada
            cliente.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
            
            clientes.append(cliente)
        }
        
        return clientes
    }
    
    private static func convertServiciosJsonToServiciosModel(serviciosJson: [JsonServiciosModel]) -> [ServiceModel] {
        var servicios: [ServiceModel] = []
        
        for servicioJson: JsonServiciosModel in serviciosJson {
            let servicio: ServiceModel = ServiceModel()
            servicio.clientId = servicioJson.clientId
            servicio.fecha = servicioJson.fecha
            servicio.empleadoId = servicioJson.profesional
            servicio.servicios = servicioJson.servicio
            servicio.precio = servicioJson.precio
            servicio.observaciones = servicioJson.observacion
            servicio.isEfectivo = true
            servicio.serviceId = servicioJson.serviceId
            servicio.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
            
            servicios.append(servicio)
        }
        
        return servicios
    }
    
    private static func convertNotificationsJsonToNotificationModels(notiJsons: [JsonNotificationModel]) -> [NotificationModel] {
        var notificaciones: [NotificationModel] = []
        
        for notiJson: JsonNotificationModel in notiJsons {
            for clientId: Int64 in notiJson.clientId {
                let notifi: NotificationModel = NotificationModel()
                notifi.clientId = clientId
                notifi.descripcion = notiJson.descripcion
                notifi.fecha = notiJson.fecha
                notifi.leido = notiJson.leido
                notifi.type = notiJson.type
                notifi.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
                
                notificaciones.append(notifi)
            }
        }
        
        return notificaciones
    }
    
    private static func convertJsonCierreCajasToCierreCajasModel(cierreCajasJson: [JsonCierreCajaModel]) -> [CierreCajaModel] {
        var cierreCajas: [CierreCajaModel] = []
        
        for cajaJson: JsonCierreCajaModel in cierreCajasJson {
            let cierreCaja: CierreCajaModel = CierreCajaModel()
            cierreCaja.fecha = cajaJson.fecha
            cierreCaja.numeroServicios = cajaJson.numeroServicios
            cierreCaja.totalCaja = cajaJson.totalCaja
            cierreCaja.totalProductos = cajaJson.totalProductos
            cierreCaja.efectivo = cajaJson.efectivo
            cierreCaja.tarjeta = cajaJson.tarjeta
            cierreCaja.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
            
            cierreCajas.append(cierreCaja)
        }
        
        return cierreCajas
    }
    
    private static func saveEmpleadosInServer(empleados: [EmpleadoModel], tipoServicios: [TipoServicioModel], clientes: [ClientModel], servicios: [ServiceModel], notificaciones: [NotificationModel]) {
        var json: [[String: Any]] = []
        let urlString: String = WebServices.baseUrl + "save_empleados"
        var controlEmpleados: [ControlModel] = []
        for empleado: EmpleadoModel in empleados {
            controlEmpleados.append(ControlModel(identificador1: empleado.fecha, identificador2: "", antiguaId: empleado.empleadoId))
            empleado.empleadoId = 0
            json.append(empleado.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let empleadosResult: [EmpleadoModel] = try! JSONDecoder().decode([EmpleadoModel].self, from: response.data!)
                    for empleadoControl: ControlModel in controlEmpleados {
                        for empleado: EmpleadoModel in empleadosResult {
                            if empleado.fecha == empleadoControl.identificador1 {
                                empleadoControl.nuevaId = empleado.empleadoId
                            }
                        }
                    }
                    
                    for empleado: EmpleadoModel in empleadosResult {
                        Constants.databaseManager.empleadosManager.addEmpleadoToDatabase(newEmpleado: empleado)
                    }
                    
                    saveTipoServiciosInServer(tipoServicios: tipoServicios, empleadosControl: controlEmpleados, clientes: clientes, servicios: servicios, notificaciones: notificaciones)
                }
            }
        }
    }
    
    private static func saveTipoServiciosInServer(tipoServicios: [TipoServicioModel], empleadosControl: [ControlModel], clientes: [ClientModel], servicios: [ServiceModel], notificaciones: [NotificationModel]) {
        let urlString: String = WebServices.baseUrl + "save_tipo_servicios"
        var controlTipoServicios: [ControlModel] = []
        var json: [[String: Any]] = []
        for servicio: TipoServicioModel in tipoServicios {
            controlTipoServicios.append(ControlModel(identificador1: 0, identificador2: servicio.nombre, antiguaId: servicio.servicioId))
            servicio.servicioId = 0
            json.append(servicio.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let tipoServiciosResult: [TipoServicioModel] = try! JSONDecoder().decode([TipoServicioModel].self, from: response.data!)
                    for tipoServicioControl: ControlModel in controlTipoServicios {
                        for tipoServicio: TipoServicioModel in tipoServiciosResult {
                            if tipoServicio.nombre == tipoServicioControl.identificador2 {
                                tipoServicioControl.nuevaId = tipoServicio.servicioId
                            }
                        }
                    }
                    
                    for tipoServicio: TipoServicioModel in tipoServiciosResult {
                        Constants.databaseManager.tipoServiciosManager.addTipoServicioToDatabase(servicio: tipoServicio)
                    }
                    
                    updateIdsInServicios(servicios: servicios, controlEmpleados: empleadosControl, controlTipoServicios: controlTipoServicios)

                    saveClientesInServer(clientes: clientes, servicios: servicios, notificaciones: notificaciones)
                }
            }
        }
    }
    
    private static func saveClientesInServer(clientes: [ClientModel], servicios: [ServiceModel], notificaciones: [NotificationModel]) {
        let clientesAgrupados: [ClientMasServicios] = agruparServiciosPorCliente(clientes: clientes, servicios: servicios)
        
        let urlString: String = WebServices.baseUrl + "save_clientes"
        var controlClientes: [ControlModel] = []
        var json: [[String: Any]] = []
        for clienteAgrupado: ClientMasServicios in clientesAgrupados {
            controlClientes.append(ControlModel(identificador1: 0, identificador2: clienteAgrupado.cliente.nombre + clienteAgrupado.cliente.apellidos, antiguaId: clienteAgrupado.cliente.id))
            clienteAgrupado.cliente.id = 0
            json.append(clienteAgrupado.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let clientesAgrupadosResult: [ClientMasServicios] = try! JSONDecoder().decode([ClientMasServicios].self, from: response.data!)
                    for clienteControl: ControlModel in controlClientes {
                        for clienteAgrupado: ClientMasServicios in clientesAgrupadosResult {
                            if clienteAgrupado.cliente.nombre + clienteAgrupado.cliente.apellidos == clienteControl.identificador2 {
                                clienteControl.nuevaId = clienteAgrupado.cliente.id
                            }
                        }
                    }
                    
                    for clienteAgrupado: ClientMasServicios in clientesAgrupadosResult {
                        Constants.databaseManager.clientsManager.addClientToDatabase(newClient: clienteAgrupado.cliente)
                        for servicio: ServiceModel in clienteAgrupado.servicios {
                            Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
                        }
                    }
                    
                    updateClientIdsInNotifications(notifications: notificaciones, controlClientes: controlClientes)
                    saveNotificacionesInServer(notificaciones: notificaciones)
                }
            }
        }
    }
    
    private static func saveNotificacionesInServer(notificaciones: [NotificationModel]) {
        let urlString: String = WebServices.baseUrl + "save_notifications"
        var json: [[String: Any]] = []
        for notification: NotificationModel in notificaciones {
            notification.notificationId = 0
            json.append(notification.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let notifications: [NotificationModel] = try! JSONDecoder().decode([NotificationModel].self, from: response.data!)
                    
                    for notification: NotificationModel in notifications {
                        Constants.databaseManager.notificationsManager.addNotificationToDatabase(newNotification: notification)
                    }
                }
            }
        }
    }
    
    private static func saveCierreDeCajasInServer(cierreCajas: [CierreCajaModel]) {
        let urlString: String = WebServices.baseUrl + "save_cierre_cajas"
        var json: [[String: Any]] = []
        for cierreCaja: CierreCajaModel in cierreCajas {
            cierreCaja.cajaId = 0
            json.append(cierreCaja.createJson())
        }
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.headers = WebServices.createHeaders()
        request.method = .post
        request.httpBody = try! JSONSerialization.data(withJSONObject: json, options: [])
        AF.request(request).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let cierreCajasResult: [CierreCajaModel] = try! JSONDecoder().decode([CierreCajaModel].self, from: response.data!)
                    
                    for caja: CierreCajaModel in cierreCajasResult {
                        Constants.databaseManager.cierreCajaManager.addCierreCajaToDatabase(newCierreCaja: caja)
                    }
                }
            }
        }
    }
    
    private static func updateIdsInServicios(servicios: [ServiceModel], controlEmpleados: [ControlModel], controlTipoServicios: [ControlModel]) {
        for servicio: ServiceModel in servicios {
            for empleado: ControlModel in controlEmpleados {
                if empleado.antiguaId == servicio.empleadoId {
                    servicio.empleadoId = empleado.nuevaId
                }
            }
            
            if servicio.servicios.count > 0 {
                for i in 0...servicio.servicios.count - 1 {
                    for tipoServicio: ControlModel in controlTipoServicios {
                        if servicio.servicios[i] == tipoServicio.antiguaId {
                            servicio.servicios[i] = tipoServicio.nuevaId
                        }
                    }
                }
            }

            servicio.serviceId = 0
        }
    }
    
    private static func agruparServiciosPorCliente(clientes: [ClientModel], servicios: [ServiceModel]) -> [ClientMasServicios] {
        var clientesAgrupados: [ClientMasServicios] = []
        for cliente: ClientModel in clientes {
            var serviciosDelCliente: [ServiceModel] = []
            for servicio: ServiceModel in servicios {
                if servicio.clientId == cliente.id {
                    servicio.clientId = 0
                    serviciosDelCliente.append(servicio)
                }
            }
            
            clientesAgrupados.append(ClientMasServicios(cliente: cliente, servicios: serviciosDelCliente))
        }
        
        return clientesAgrupados
    }
    
    private static func updateClientIdsInNotifications(notifications: [NotificationModel], controlClientes: [ControlModel]) {
        for notification: NotificationModel in notifications {
            for controlCliente: ControlModel in controlClientes {
                if notification.clientId == controlCliente.antiguaId {
                    notification.clientId = controlCliente.nuevaId
                }
            }
        }
    }
}
