//
//  WebServices.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import Alamofire


public class WebServices {
    private static let baseUrl: String = "https://gestor.djmrbug.com:8443/api/"
    
    private static func createHeaders() -> HTTPHeaders {
        let token: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesTokenKey) as! String
        let headers: HTTPHeaders = ["Authorization": "Bearer " + token, "Content-Type": "application/json", "UniqueDeviceId" : CommonFunctions.getUniqueDeviceId()]
        return headers
    }
    
    static func getEstiloLogin(bundleId: String, delegate: LoginProtocol) {
        let url: String = baseUrl + "get_estilo_publico/" + bundleId
        AF.request(url, method: .get).responseJSON { (response) in
            if response.error == nil && response.response!.statusCode == 200 {
                let estilo: EstiloLoginModel = try! JSONDecoder().decode(EstiloLoginModel.self, from: response.data!)
                delegate.successGettingLoginStyle(estiloLogin: estilo)
            } else {
                delegate.errorGettingLoginStyle()
            }
        }
    }
    
    static func login(login: LoginModel, delegate: LoginProtocol) {
        let url: String = baseUrl + "login_comercio"
        AF.request(url, method: .post, parameters: login.createJsonForLogin(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let loginCompleto: LoginMasDispositivosModel = try! JSONDecoder().decode(LoginMasDispositivosModel.self, from: response.data!)
                    delegate.succesLogingIn(login: loginCompleto.login)
                } else if response.response!.statusCode == 413 {
                    let loginCompleto: LoginMasDispositivosModel = try! JSONDecoder().decode(LoginMasDispositivosModel.self, from: response.data!)
                    delegate.tooMuchDevicesLogingIn(loginMasDispositivosModel: loginCompleto)
                } else {
                    delegate.errorLoginIn()
                }
            }else {
                delegate.errorLoginIn()
            }
        }
    }
    
    static func registerAndUnregisterDevices(loginMasDispositivos: LoginMasDispositivosModel, delegate: LoginProtocol) {
        let url: String = baseUrl + "login_swap_devices"
        loginMasDispositivos.login.nombre_dispositivo = UIDevice.modelName
        loginMasDispositivos.login.unique_deviceId = CommonFunctions.getUniqueDeviceId()
        AF.request(url, method: .post, parameters: loginMasDispositivos.createJsonForLogin(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let loginCompleto: LoginMasDispositivosModel = try! JSONDecoder().decode(LoginMasDispositivosModel.self, from: response.data!)
                    delegate.succesLogingIn(login: loginCompleto.login)
                } else {
                    delegate.errorLoginIn()
                }
            }else {
                delegate.errorLoginIn()
            }
        }
    }
    
    static func getClientes(comercioId: Int64, delegate: ListaClientesProtocol) {
        let url: String = baseUrl + "get_clientes/" + String(comercioId)
        AF.request(url, method: .get, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let clientes: [ClientModel] = try! JSONDecoder().decode([ClientModel].self, from: response.data!)
                    for cliente: ClientModel in clientes {
                        if Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: cliente.id) == nil {
                            Constants.databaseManager.clientsManager.addClientToDatabase(newClient: cliente)
                        } else {
                            Constants.databaseManager.clientsManager.updateClientInDatabase(client: cliente)
                        }
                        
                    }
                    delegate.successGettingClients()
                    return
                }
            }
            
            delegate.errorGettingClients()
        }
    }
    
    static func addClient(model: ClientMasServicios, delegate: AddClientAndServicesProtocol) {
        let url: String = baseUrl + "save_cliente"
        let comercioId: Int64 = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        model.cliente.comercioId = comercioId
        for servicio: ServiceModel in model.servicios {
            servicio.comercioId = comercioId
        }
        AF.request(url, method: .post, parameters: model.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response?.statusCode == 200 {
                    let model :ClientMasServicios = try! JSONDecoder().decode(ClientMasServicios.self, from: response.data!)
                    delegate.succesSavingClient(model: model)
                    return
                }
            }
            
            delegate.errorSavignClient()
        }
    }
    
    static func updateClient(cliente: ClientModel, delegate: UpdateClientProtocol) {
        let url: String = baseUrl + "update_cliente"
        AF.request(url, method: .put, parameters: cliente.createClientJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let model :ClientMasServicios = try! JSONDecoder().decode(ClientMasServicios.self, from: response.data!)
                    delegate.successUpdatingClient(cliente: model.cliente)
                    return
                }
            }
            
            delegate.errorUpdatingClient()
        }
    }
    
    static func getServices(comercioId: Int64, delegate: GetServiciosProtocol) {
        let url: String = baseUrl + "get_servicios/" + String(comercioId)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers:  createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicios: [ServiceModel] = try! JSONDecoder().decode([ServiceModel].self, from: response.data!)
                    for servicio : ServiceModel in servicios {
                        if Constants.databaseManager.servicesManager.getServiceFromDatabase(serviceId: servicio.serviceId).count == 0 {
                            Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
                        } else {
                            Constants.databaseManager.servicesManager.updateServiceInDatabase(service: servicio)
                        }
                    }
                    
                    deleteLocalServicesIfNeeded(serverServices: servicios)
                    delegate.successGettingServicios()
                    return
                }
            }
            
            delegate.errorGettingServicios()
        }
    }
    
    private static func deleteLocalServicesIfNeeded(serverServices: [ServiceModel]) {
        let localServices: [ServiceModel] = Constants.databaseManager.servicesManager.getAllServicesFromDatabase()
        for localService: ServiceModel in localServices {
            var servicioExists: Bool = false
            for serverService: ServiceModel in serverServices {
                if localService.serviceId == serverService.serviceId {
                    servicioExists = true
                }
            }
            
            if !servicioExists {
                Constants.databaseManager.servicesManager.deleteService(service: localService)
            }
        }
    }
    
    static func addService(service: ServiceModel, delegate: AddNuevoServicioProtocol) {
        let url: String = baseUrl + "save_servicio"
        service.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        AF.request(url, method: .post, parameters: service.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let servicio :ServiceModel = try! JSONDecoder().decode(ServiceModel.self, from: response.data!)
                    delegate.successSavingService(servicio: servicio)
                    return
                }
            }
            
            delegate.errorSavingServicio()
        }
    }
    
    static func updateService(service: ServiceModel, delegate: UpdateServicioProtocol) {
        let url: String = baseUrl + "update_servicio"
        AF.request(url, method: .put, parameters: service.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let servicio :ServiceModel = try! JSONDecoder().decode(ServiceModel.self, from: response.data!)
                    delegate.successUpdatingService(service: servicio)
                    return
                }
            }
            
            delegate.errorUpdatingService()
        }
    }
    
    static func updateNotificacionPersonalizada(cliente: ClientModel, delegate: UpdateNotificacionPersonalizadaProtocol) {
        let url: String = baseUrl + "update_notificacion_personalizada"
        AF.request(url, method: .put, parameters: cliente.createClientJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let cliente :ClientModel = try! JSONDecoder().decode(ClientModel.self, from: response.data!)
                    delegate.successUpdatingNotificacion(cliente: cliente)
                    return
                }
            }
            
            delegate.errorUpdatingNotificacion()
        }
    }
    
    static func getEmpleados(comercioId: Int64, delegate: GetEmpleadosProtocol) {
        let url: String = baseUrl + "get_empleados/" + String(comercioId)
        AF.request(url, method: .get, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleados: [EmpleadoModel] = try! JSONDecoder().decode([EmpleadoModel].self, from: response.data!)
                    for empleado: EmpleadoModel in empleados {
                        if Constants.databaseManager.empleadosManager.getEmpleadoFromDatabase(empleadoId: empleado.empleadoId) == nil {
                            Constants.databaseManager.empleadosManager.addEmpleadoToDatabase(newEmpleado: empleado)
                        } else {
                            Constants.databaseManager.empleadosManager.updateEmpleado(empleado: empleado)
                        }
                    }
                    
                    compareLocalEmpleadosWithServerEmpleados(serverEmpleados: empleados)
                    
                    delegate.succesGettingEmpleados(empleados: empleados)
                    return
                }
            }
            
            delegate.errorGettingEmpleados()
        }
    }
    
    private static func compareLocalEmpleadosWithServerEmpleados(serverEmpleados: [EmpleadoModel]) {
        let localEmpleados: [EmpleadoModel] = Constants.databaseManager.empleadosManager.getAllEmpleadosFromDatabase()
        for localEmpleado: EmpleadoModel in localEmpleados {
            var empleadoExiste: Bool = false
            for serverEmpleado: EmpleadoModel in serverEmpleados {
                if serverEmpleado.empleadoId == localEmpleado.empleadoId {
                    empleadoExiste = true
                }
            }
            
            if !empleadoExiste {
                Constants.databaseManager.empleadosManager.eliminarEmpleado(empleadoId: localEmpleado.empleadoId)
            }
        }
    }
    
    static func addEmpleado(empleado: EmpleadoModel, delegate: AddEmpleadoProtocol) {
        let url: String = baseUrl + "save_empleado"
        empleado.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        print("")
        AF.request(url, method: .post, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let empleado: EmpleadoModel = try! JSONDecoder().decode(EmpleadoModel.self, from: response.data!)
                    delegate.successSavingEmpleado(empleado: empleado)
                    return
                }
            }
            
            delegate.errorSavingEmpleado()
        }
    }
    
    static func updateEmpleado(empleado: EmpleadoModel, delegate: UpdateEmpleadoProtocol) {
        let url: String = baseUrl + "update_empleado"
        AF.request(url, method: .put, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleado: EmpleadoModel = try! JSONDecoder().decode(EmpleadoModel.self, from: response.data!)
                    delegate.successUpdatingEmpleado(empleado: empleado)
                    return
                }
            }
            
            delegate.errorUpdatingEmpleado()
        }
    }
    
    static func deleteEmpleado(empleado: EmpleadoModel, delegate: DeleteEmpleadoProtocol) {
        let url: String = baseUrl + "delete_empleado"
        AF.request(url, method: .post, parameters: empleado.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let empleadoMasServicios: EmpleadoMasServicios = try! JSONDecoder().decode(EmpleadoMasServicios.self, from: response.data!)
                    delegate.successDeletingEmpleado(empleadoMasServicios: empleadoMasServicios)
                    return
                }
            }
            
            delegate.errorDeletingEmpleado()
        }
    }
    
    static func getTipoServicios(comercioId: Int64, delegate: GetTipoServiciosProtocol) {
        let url: String = baseUrl + "get_tipo_servicios/" + String(comercioId)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 200 {
                    let tipoServicios: [TipoServicioModel] = try! JSONDecoder().decode([TipoServicioModel].self, from: response.data!)
                    for tipoServicio: TipoServicioModel in tipoServicios {
                        Constants.databaseManager.tipoServiciosManager.addTipoServicioToDatabase(servicio: tipoServicio)
                    }
                    
                    delegate.successGettingServicios()
                    return
                }
            }
            
            delegate.errorGettingServicios()
        }
    }
    
    static func addTipoServicio(tipoServicio: TipoServicioModel, delegate: AddTipoServicioProtocol) {
        let url: String = baseUrl + "save_tipo_servicio"
        tipoServicio.comercioId = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64
        AF.request(url, method: .post, parameters: tipoServicio.createJson(), encoding: JSONEncoding.default, headers: createHeaders()).responseJSON { (response) in
            if response.error == nil {
                if response.response!.statusCode == 201 {
                    let tipoServicio: TipoServicioModel = try! JSONDecoder().decode(TipoServicioModel.self, from: response.data!)
                    delegate.successSavingServicio(tipoServicio: tipoServicio)
                    return
                }
            }
            
            delegate.errorSavingServicio()
        }
    }
}
