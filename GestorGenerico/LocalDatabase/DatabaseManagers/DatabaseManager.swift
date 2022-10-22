//
//  DatabaseManager.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    var clientsManager: ClientesManager!
    var servicesManager: ServicesManager!
    var notificationsManager: NotificationsManager!
    var empleadosManager: EmpleadosManager!
    var tipoServiciosManager: TipoServiciosManager!
    var cierreCajaManager: CierreCajaManager!
    var estiloAppManager: AppStyleManager!
    var productosManager: ProductoManager!
    var cestaManager: CestaManager!
    var ventaManager: VentaManager!
    
    override init() {
        super.init()
        clientsManager = ClientesManager()
        servicesManager = ServicesManager()
        notificationsManager = NotificationsManager()
        empleadosManager = EmpleadosManager()
        tipoServiciosManager = TipoServiciosManager()
        cierreCajaManager = CierreCajaManager()
        estiloAppManager = AppStyleManager()
        productosManager = ProductoManager()
        cestaManager = CestaManager()
        ventaManager = VentaManager()
    }
    
    func clearAllDatabase() {
        clientsManager.deleteAllClients()
        servicesManager.deleteAllServices()
        notificationsManager.deleteAllNotifications()
        empleadosManager.deleteAllEmpleados()
        tipoServiciosManager.deleteAllTipoServicios()
        cierreCajaManager.deleteAllCierreCajas()
        estiloAppManager.deleteStyle()
        productosManager.deleteAllProductos()
        cestaManager.deleteAllCestas()
        ventaManager.deleteAllVentas()
    }
}
