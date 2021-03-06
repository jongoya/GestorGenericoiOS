//
//  AddServicioViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 02/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddServicioViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var professionalLabel: UILabel!
    @IBOutlet weak var servicioLabel: UILabel!
    @IBOutlet weak var observacionLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var efectivoSwitch: UISwitch!
    
    @IBOutlet weak var tituloField: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var profesionalField: UILabel!
    @IBOutlet weak var servicioField: UILabel!
    @IBOutlet weak var precioField: UILabel!
    @IBOutlet weak var efectivoField: UILabel!
    
    @IBOutlet weak var fechaArrow: UIImageView!//chevron.righ
    @IBOutlet weak var profesionalArrow: UIImageView!
    @IBOutlet weak var servicioArrow: UIImageView!
    @IBOutlet weak var precioArrow: UIImageView!
    
    var client: ClientModel!
    var service: ServiceModel = ServiceModel()
    var modifyService: Bool = false
    var delegate: AddServicioProtocol!
    var modificacionHecha: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  modifyService ? "Servicio" : "Nuevo Servicio"
        efectivoSwitch.addTarget(self, action: #selector(switchClicked), for: UIControl.Event.valueChanged)
        customizeScrollView()
        customizeFields()
        customizeLabels()
        customizeArrows()
        customizeSwitch()
        addBackButton()
        setMainValues()
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        professionalLabel.textColor = AppStyle.getSecondaryTextColor()
        servicioLabel.textColor = AppStyle.getSecondaryTextColor()
        precioLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        tituloField.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        profesionalField.textColor = AppStyle.getPrimaryTextColor()
        servicioField.textColor = AppStyle.getPrimaryTextColor()
        precioField.textColor = AppStyle.getPrimaryTextColor()
        efectivoField.textColor = AppStyle.getPrimaryTextColor()
        observacionLabel.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        profesionalArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        servicioArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        precioArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        profesionalArrow.tintColor = AppStyle.getSecondaryColor()
        servicioArrow.tintColor = AppStyle.getSecondaryColor()
        precioArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizeSwitch() {
        efectivoSwitch.onTintColor = AppStyle.getPrimaryColor()
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setMainValues() {
        nombreLabel.text = client.nombre + " " + client.apellidos
        
        if modifyService {
            setAllFields()
        }
    }
    
    func setAllFields() {
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(service.fecha)))
        professionalLabel.text = Constants.databaseManager.empleadosManager.getEmpleadoFromDatabase(empleadoId: service.empleadoId)?.nombre
        servicioLabel.text = CommonFunctions.getServiciosStringFromServiciosArray(servicios: service.servicios)
        observacionLabel.text = service.observaciones
        precioLabel.text = String(format: "%.2f", service.precio) + " €"
        if service.observaciones.count == 0 {
            observacionLabel.text = "Añade una observación"
        }
        
        if service.isEfectivo {
            efectivoSwitch.isOn = true
        }
    }
    
    func getArrayForInputReference(inputReference: Int) -> [Any] {
        switch inputReference {
        case 1:
            return CommonFunctions.getProfessionalList()
        default:
            return CommonFunctions.getServiceList()
        }
    }
    
    func checkFields() {
        if fechaLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir una fecha", viewController: self)
            return
        }
        
        if professionalLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar a una profesional", viewController: self)
            return
        }
        
        if servicioLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un servicio", viewController: self)
            return
        }
        
        if client.id != 0 {
            if !modifyService {
                saveService()
            } else {
                updateService()
            }
        } else {
            delegate.serviceContentFilled(service: service, serviceUpdated: modifyService)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveService() {
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando servicio")
        service.clientId = client.id
        WebServices.addService(service: service, delegate: self)
    }
    
    func updateService() {
        CommonFunctions.showLoadingStateView(descriptionText: "Actualizando servicio")
        WebServices.updateService(service: service, delegate: self)
    }
    
    func showChangesAlertMessage() {
        let alertController = UIAlertController(title: "Aviso", message: "Varios datos han sido modificados, ¿desea volver sin guardar?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didClickBackButton))
    }
    
    func getTitleForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 0:
            return "Precio"
        default:
            return "Observaciones"
        }
    }
    
    func getValueForInputReference(inputReference: Int) -> String {
        switch inputReference {
        case 0:
            return service.precio > 0 ? String(format: "%.2f", service.precio) : ""
        default:
            return service.observaciones
        }
    }
    
    func getKeyboardTypeForInputReference(inputReference: Int) -> UIKeyboardType {
        switch inputReference {
        case 0:
            return .decimalPad
        default:
            return .default
        }
    }
    
    func returnToPreviousScreen() {
        CommonFunctions.hideLoadingStateView()
        self.delegate.serviceContentFilled(service: self.service, serviceUpdated: self.modifyService)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddServicioViewController {
    @IBAction func didClickFechaButton(_ sender: Any) {
        performSegue(withIdentifier: "DatePickerSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickProfesionalButton(_ sender: Any) {
        performSegue(withIdentifier: "ListSelectorIdentifier", sender: 1)
    }
    
    @IBAction func didClickServicioButton(_ sender: Any) {
        performSegue(withIdentifier: "ListSelectorIdentifier", sender: 2)
    }
    
    @IBAction func didClickObservacion(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickSaveButton(_ sender: Any) {
        checkFields()
    }
    
    @IBAction func didClickPrecioButton(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 0)
    }
    
    @objc func didClickBackButton(sender: UIBarButtonItem) {
        if modifyService {
            if !modificacionHecha {
                self.navigationController?.popViewController(animated: true)
            } else {
                showChangesAlertMessage()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func switchClicked(mySwitch: UISwitch) {
        service.isEfectivo = efectivoSwitch.isOn
    }
}

extension AddServicioViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        modificacionHecha = true
        service.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: date)
    }
}

extension AddServicioViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DatePickerSelectorIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .dateAndTime
            controller.initialDate = service.fecha
        } else if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForInputReference(inputReference: (sender as! Int))
            controller.inputText = getValueForInputReference(inputReference: (sender as! Int))
            controller.title = getTitleForInputReference(inputReference: (sender as! Int))
        } else if segue.identifier == "ListSelectorIdentifier" {
            let controller: ListSelectorViewController = segue.destination as! ListSelectorViewController
            controller.delegate = self
            controller.inputReference = (sender as! Int)
            controller.listOptions = getArrayForInputReference(inputReference: (sender as! Int))
            controller.allowMultiselection = (sender as! Int) == 2 ? true : false
        }
    }
}

extension AddServicioViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        modificacionHecha = true
        
        switch inputReference {
        case 0:
            let value = text.replacingOccurrences(of: ",", with: ".")
            precioLabel.text = value + " €"
            service.precio = (value as NSString).doubleValue
            break
        default:
            service.observaciones = text
            observacionLabel.text = text
        }
    }
}

extension AddServicioViewController: ListSelectorProtocol {
    func multiSelectionOptionsSelected(options: [Any], inputReference: Int) {
        modificacionHecha = true
        switch inputReference {
            case 2:
                service.servicios = CommonFunctions.getServiciosIdentifiers(servicios: (options as! [TipoServicioModel]))
                servicioLabel.text = CommonFunctions.getServiciosString(servicios: (options as! [TipoServicioModel]))
            default:
                break
        }
    }
    
    func optionSelected(option: Any, inputReference: Int) {
        modificacionHecha = true
        switch inputReference {
        case 1:
            service.empleadoId = (option as! EmpleadoModel).empleadoId
            professionalLabel.text = (option as! EmpleadoModel).nombre
        default:
            service.servicios = [(option as! TipoServicioModel).servicioId]
            servicioLabel.text = (option as! TipoServicioModel).nombre
        }
    }
}

extension AddServicioViewController: AddNuevoServicioProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successSavingService(servicio: ServiceModel) {
        Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
        let notifications: [NotificationModel] = Constants.databaseManager.notificationsManager.getAllNotificationsForClientAndNotificationType(notificationType: Constants.notificacionCadenciaIdentifier, clientId: client.id)
        for notificacion: NotificationModel in notifications {
            Constants.databaseManager.notificationsManager.eliminarNotificacion(notificationId: notificacion.notificationId)
        }
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.returnToPreviousScreen()
        }
    }
    
    func errorSavingServicio() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error Guardando el servicio", viewController: self)
        }
    }
}

extension AddServicioViewController: UpdateServicioProtocol {
    func successUpdatingService(service: ServiceModel) {
        Constants.databaseManager.servicesManager.updateServiceInDatabase(service: service)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.returnToPreviousScreen()
        }
    }
    
    func errorUpdatingService() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error Actualizando el servicio", viewController: self)
        }
    }
}

