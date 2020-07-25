//
//  AddClientViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 01/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nombreView: UIView!
    @IBOutlet weak var apellidosView: UIView!
    @IBOutlet weak var fechaView: UIView!
    @IBOutlet weak var telefonoView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var direccionView: UIView!
    @IBOutlet weak var cadenciaView: UIView!
    @IBOutlet weak var observacionesView: UIView!
    @IBOutlet weak var addServicioView: UIView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidosLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!
    @IBOutlet weak var cadenciaLabel: UILabel!
    @IBOutlet weak var observacionesLabel: UILabel!
    
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var apellidosField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var telefonoField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var direccionField: UILabel!
    @IBOutlet weak var cadenciaField: UILabel!
    @IBOutlet weak var informacionField: UILabel!
    @IBOutlet weak var plusButtonField: UILabel!
    
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var apellidosArrow: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var telefonoArrow: UIImageView!
    @IBOutlet weak var emailArrow: UIImageView!
    @IBOutlet weak var dirrecionArrow: UIImageView!
    @IBOutlet weak var cadenciaArrow: UIImageView!
    @IBOutlet weak var plusButtonImage: UIImageView!
    
    @IBOutlet weak var addServicioTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var clientImageView: UIImageView!
    @IBOutlet weak var clientImageContainer: UIView!
    
    var newClient: ClientModel = ClientModel()
    var servicios: [ServiceModel] = []
    var addServicioPreviousView: UIView!
    var delegate: AddClientProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonFunctions.customizeButton(button: addServicioView)
        customizeScrollView()
        customizePlaceholder()
        customizeLabels()
        customizeFields()
        customizeArrows()
        customizePlusButton()
        title = "Añadir Cliente"
        addServicioPreviousView = observacionesView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if delegate != nil {
            addServicioView.isHidden = true
        }
    }
    
    func customizePlaceholder() {
        clientImageView.image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
        clientImageView.tintColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeImageView() {
        clientImageView.layer.cornerRadius = 75
    }
    
    func customizeScrollView() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        apellidosLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        telefonoLabel.textColor = AppStyle.getSecondaryTextColor()
        emailLabel.textColor = AppStyle.getSecondaryTextColor()
        direccionLabel.textColor = AppStyle.getSecondaryTextColor()
        cadenciaLabel.textColor = AppStyle.getSecondaryTextColor()
        observacionesLabel.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeFields() {
        informacionField.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        apellidosField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        telefonoField.textColor = AppStyle.getPrimaryTextColor()
        emailField.textColor = AppStyle.getPrimaryTextColor()
        direccionField.textColor = AppStyle.getPrimaryTextColor()
        cadenciaField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        apellidosArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        telefonoArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        emailArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        dirrecionArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        cadenciaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        apellidosArrow.tintColor = AppStyle.getSecondaryColor()
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        telefonoArrow.tintColor = AppStyle.getSecondaryColor()
        emailArrow.tintColor = AppStyle.getSecondaryColor()
        dirrecionArrow.tintColor = AppStyle.getSecondaryColor()
        cadenciaArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func customizePlusButton() {
        plusButtonImage.image = UIImage(systemName: "plus")!.withRenderingMode(.alwaysTemplate)
        plusButtonImage.tintColor = AppStyle.getPrimaryColor()
        plusButtonField.textColor = AppStyle.getPrimaryColor()
    }
    
    func showServicio(servicio: ServiceModel) {
        let view: ServicioView = ServicioView(service: servicio, client: newClient, cesta: nil)
        scrollContentView.addSubview(view)
        view.topAnchor.constraint(equalTo: addServicioPreviousView.bottomAnchor, constant: 30).isActive = true
        view.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 15).isActive = true
        view.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -15).isActive = true
        addServicioPreviousView = view
        
        addServicioTopConstraint = addServicioView.topAnchor.constraint(equalTo: addServicioPreviousView.bottomAnchor, constant: 30)
        addServicioTopConstraint.isActive = true
        addServicioView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20).isActive = true
    }
    
    func checkFields() {
        if nombreLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir el nombre del cliente", viewController: self)
            return
        }
        
        if apellidosLabel.text!.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir por lo menos un apellido del cliente", viewController: self)
            return
        }
        
        if telefonoLabel.text!.count < 9 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un número de contacto válido", viewController: self)
            return
        }
        
        saveClient()
    }
    
    func saveClient() {
        CommonFunctions.showLoadingStateView(descriptionText: "Guardando cliente")
        WebServices.addClient(model: ClientMasServicios(cliente: newClient, servicios: servicios), delegate: self)
    }
}

extension AddClientViewController {
    @IBAction func didClickAñadirServicioButton(_ sender: Any) {
        if newClient.nombre.count == 0 || newClient.apellidos.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir al menos el nombre y apellidos del cliente", viewController: self)
            return
        }
        
        performSegue(withIdentifier: "AddServicioIdentifier", sender: nil)
    }
    
    @IBAction func didClickNombreField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 1)
    }
    
    @IBAction func didClickApellidosField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 2)
    }
    
    @IBAction func didClickFechaField(_ sender: Any) {
        performSegue(withIdentifier: "DatePickerSelectorIdentifier", sender: nil)
    }
    
    @IBAction func didClickTelefonoField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 3)
    }
    
    @IBAction func didClickEmailField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 4)
    }
    
    @IBAction func didClickDireccionField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 5)
    }
    
    @IBAction func didClickCadenciaField(_ sender: Any) {
        performSegue(withIdentifier: "pickerSelectorIdentifier", sender: 0)
    }
    
    @IBAction func didClickObservacionesField(_ sender: Any) {
        performSegue(withIdentifier: "FieldIdentifier", sender: 7)
    }
    
    @IBAction func didClickSaveClient(_ sender: Any) {
        checkFields()
    }
    
    @IBAction func didClickClientImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension AddClientViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            newClient.nombre = text
            nombreLabel.text = text
            break
        case 2:
            newClient.apellidos = text
            apellidosLabel.text = text
            break
        case 3:
            newClient.telefono = text
            telefonoLabel.text = text
            break
        case 4:
            newClient.email = text
            emailLabel.text = text
            break
        case 5:
            newClient.direccion = text
            direccionLabel.text = text
            break
        default:
            newClient.observaciones = text
            observacionesLabel.text = text
            break
        }
    }
}

extension AddClientViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        newClient.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: date)
    }
}

extension AddClientViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FieldIdentifier" {
            let controller: FieldViewController = segue.destination as! FieldViewController
            controller.inputReference = (sender as! Int)
            controller.delegate = self
            controller.keyboardType = getKeyboardTypeForField(inputReference: (sender as! Int))
            controller.inputText = getInputTextForField(inputReference: (sender as! Int))
            controller.title = getControllerTitleForField(inputReference: (sender as! Int))
        } else if segue.identifier == "DatePickerSelectorIdentifier" {
            let controller: DatePickerSelectorViewController = segue.destination as! DatePickerSelectorViewController
            controller.delegate = self
            controller.datePickerMode = .date
            controller.initialDate = newClient.fecha
        } else if segue.identifier == "AddServicioIdentifier" {
            let controller: AddServicioViewController = segue.destination as! AddServicioViewController
            controller.client = newClient
            controller.delegate = self
        } else if segue.identifier == "pickerSelectorIdentifier" {
            let controller: PickerSelectorViewController = segue.destination as! PickerSelectorViewController
            controller.delegate = self
        }
    }
    
    func getKeyboardTypeForField(inputReference: Int) -> UIKeyboardType {
        switch inputReference {
        case 3:
            return .phonePad
        case 4:
            return .emailAddress
        default:
            return .default
        }
    }
    
    func getInputTextForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return nombreLabel.text!
        case 2:
            return apellidosLabel.text!
        case 3:
            return telefonoLabel.text!
        case 4:
            return emailLabel.text!
        case 5:
            return direccionLabel.text!
        default:
            return newClient.observaciones
        }
    }
    
    func getControllerTitleForField(inputReference: Int) -> String {
        switch inputReference {
        case 1:
            return "Nombre"
        case 2:
            return "Apellidos"
        case 3:
            return "Telefono"
        case 4:
            return "Email"
        case 5:
            return "Dirección"
        default:
            return "Observaciones"
        }
    }
}

extension AddClientViewController: AddServicioProtocol {
    func serviceContentFilled(service: ServiceModel, serviceUpdated: Bool) {
        service.serviceId = Int64(Date().timeIntervalSince1970)
        servicios.append(service)
        addServicioTopConstraint.isActive = false
        showServicio(servicio: service)
    }
}

extension AddClientViewController: PickerSelectorProtocol {
    func cadenciaSelected(cadencia: String) {
        cadenciaLabel.text = cadencia
        newClient.cadenciaVisita = cadencia
    }
}

extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        customizeImageView()
        let image = info[.originalImage] as! UIImage
        let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 150, height: 150))
        self.clientImageView.image = resizedImage
        let imageData: Data = resizedImage.pngData()!
        let imageString: String = imageData.base64EncodedString()
        newClient.imagen = imageString
    }
}

extension AddClientViewController: AddClientAndServicesProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func succesSavingClient(model: ClientMasServicios) {
        Constants.databaseManager.clientsManager.addClientToDatabase(newClient: model.cliente)
        for servicio: ServiceModel in model.servicios {
            Constants.databaseManager.servicesManager.addServiceInDatabase(newService: servicio)
        }
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            if self.delegate != nil {//Add cliente en la agenda
                self.delegate.clientAdded(client: model.cliente)
            }
            
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorSavignClient() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando cliente", viewController: self)
        }
    }
}
