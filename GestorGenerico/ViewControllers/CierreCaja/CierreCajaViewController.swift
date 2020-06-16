//
//  CierreCajaViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 21/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class CierreCajaViewController: UIViewController {
    @IBOutlet weak var numeroServiciosLabel: UILabel!
    @IBOutlet weak var totalCajaLabel: UILabel!
    @IBOutlet weak var totalProductosLabel: UILabel!
    @IBOutlet weak var efectivoLabel: UILabel!
    @IBOutlet weak var tarjetaLabel: UILabel!
    
    var cierreCaja: CierreCajaModel = CierreCajaModel()
    var presentDate: Date!
    var notification: NotificationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cierre Caja"
        
        addSaveCierreCajaButton()
        
        fillFields()
    }
    
    func addSaveCierreCajaButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveCierreCajaButton))
    }
    
    func fillFields() {
        let services: [ServiceModel] = Constants.databaseManager.servicesManager.getServicesForDay(date: presentDate)
        numeroServiciosLabel.text = String(services.count)
        cierreCaja.numeroServicios = services.count
        totalCajaLabel.text = String(format: "%.2f", getTotalCajaFromServicios(servicios: services)) + " €"
        cierreCaja.totalCaja = getTotalCajaFromServicios(servicios: services)
        totalProductosLabel.text = String(format: "%.2f", getTotalProductosFromServicios(servicios: services)) + " €"
        cierreCaja.totalProductos = getTotalProductosFromServicios(servicios: services)
        efectivoLabel.text = String(format: "%.2f", getTotalEfectivoFromServicios(servicios: services)) + " €"
        cierreCaja.efectivo = getTotalEfectivoFromServicios(servicios: services)
        tarjetaLabel.text = String(format: "%.2f", getTotalTarjetaFromServicios(servicios: services)) + " €"
        cierreCaja.tarjeta = getTotalTarjetaFromServicios(servicios: services)
    }
    
    func getTotalCajaFromServicios(servicios: [ServiceModel]) -> Double {
        var totalCaja: Double = 0.0
        for servicio: ServiceModel in servicios {
            totalCaja = totalCaja + servicio.precio
        }
        
        return totalCaja
    }
    
    func getTotalProductosFromServicios(servicios: [ServiceModel]) -> Double {
        let ventaProductoId: Int64 = getVentaProductoId()
        var totalProductos = 0.0
        for servicio: ServiceModel in servicios {
            if servicio.servicios.contains(ventaProductoId) {
                totalProductos = totalProductos + servicio.precio
            }
        }
        
        return totalProductos
    }
    
    func getTotalEfectivoFromServicios(servicios: [ServiceModel]) -> Double {
        var totalEfectivo = 0.0
        for servicio: ServiceModel in servicios {
            if servicio.isEfectivo {
                totalEfectivo = totalEfectivo + servicio.precio
            }
        }
        
        return totalEfectivo
    }
    
    func getTotalTarjetaFromServicios(servicios: [ServiceModel]) -> Double {
        var totalTarjeta = 0.0
        for servicio: ServiceModel in servicios {
            if !servicio.isEfectivo {
                totalTarjeta = totalTarjeta + servicio.precio
            }
        }
        
        return totalTarjeta
    }
    
    func getVentaProductoId() -> Int64 {
        let tipoServicios: [TipoServicioModel] = Constants.databaseManager.tipoServiciosManager.getAllServiciosFromDatabase()
        for servicio: TipoServicioModel in tipoServicios {
            if servicio.nombre == "Venta producto" {
                return servicio.servicioId
            }
        }
        
        return 0
    }
    
    func getKeyboardTypeForField(inputReference: Int) -> UIKeyboardType {
        switch inputReference {
        case 1:
            return .numberPad
        default:
            return .decimalPad
        }
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return numeroServiciosLabel.text!
        case 2:
            return totalCajaLabel.text!
        case 3:
            return totalProductosLabel.text!
        case 4:
            return efectivoLabel.text!
        default:
            return tarjetaLabel.text!
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Número servicios"
        case 2:
            return "Total caja"
        case 3:
            return "Total productos"
        case 4:
            return "Efectivo"
        default:
            return "Tarjeta"
        }
    }
    
    func checkFields() {
        if numeroServiciosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluier un numero de servicios", viewController: self)
            return
        }
        
        if totalCajaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en la caja", viewController: self)
            return
        }
        
        if totalProductosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total de productos", viewController: self)
            return
        }
        
        if efectivoLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en efectivo", viewController: self)
            return
        }
        
        if tarjetaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un total en tarjeta", viewController: self)
            return
        }
        
        saveCierreCaja()
    }
    
    func saveCierreCaja() {
        cierreCaja.fecha = Int64(presentDate.timeIntervalSince1970)
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando el cierre de caja")
        WebServices.saveCierreCaja(caja: cierreCaja, delegate: self)
    }
}

extension CierreCajaViewController {
    @objc func didClickSaveCierreCajaButton(sender: UIBarButtonItem) {
        checkFields()
    }
    
    @IBAction func didClickNumeroServicios(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickTotalCaja(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickTotalProductos(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickEfectivo(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 4)
    }
    
    @IBAction func didClickTarjeta(_ sender: Any) {
        performSegue(withIdentifier: "inputFieldIdentifier", sender: 5)
    }
}

extension CierreCajaViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "inputFieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForField(inputReference: (sender as! Int))
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        }
    }
}

extension CierreCajaViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        let value = text.replacingOccurrences(of: ",", with: ".")
        switch inputReference {
        case 1:
            numeroServiciosLabel.text = text
            cierreCaja.numeroServicios = (text as NSString).integerValue
        case 2:
            totalCajaLabel.text = value
            cierreCaja.totalCaja = (value as NSString).doubleValue
        case 3:
            totalProductosLabel.text = value
            cierreCaja.totalProductos = (value as NSString).doubleValue
        case 4:
            efectivoLabel.text = value
            cierreCaja.efectivo = (value as NSString).doubleValue
        default:
            tarjetaLabel.text = value
            cierreCaja.tarjeta = (value as NSString).doubleValue
        }
    }
}

extension CierreCajaViewController: AddCierreCajaProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successAddingCierreCaja(caja: CierreCajaModel) {
        if notification == nil {
            Constants.databaseManager.cierreCajaManager.addCierreCajaToDatabase(newCierreCaja: caja)
            DispatchQueue.main.async {
                CommonFunctions.hideLoadingStateView()
                self.navigationController!.popViewController(animated: true)
            }
        } else {
            cierreCaja = caja
            notification.leido = true
            WebServices.deleteNotificacion(notificacion: notification, delegate: self)
        }
    }
    
    func errorAddingCierreCaja() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando el cierre de caja", viewController: self)
        }
    }
    
    
}

extension CierreCajaViewController: DeleteNotificacionProtocol {
    func successDeletingNotificacion() {
        Constants.databaseManager.cierreCajaManager.addCierreCajaToDatabase(newCierreCaja: cierreCaja)
        Constants.databaseManager.notificationsManager.eliminarNotificacion(notificationId: notification.notificationId)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            Constants.rootController.setNotificationBarItemBadge()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorDeletingNotificacion() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando el cierre de caja", viewController: self)
        }
    }
}
