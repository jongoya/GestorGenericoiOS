//
//  AddEmpleadoViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 12/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AddEmpleadoViewController: UIViewController {
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var apellidosLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var telefonoLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    @IBOutlet weak var informcaionLabel: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var apellidosField: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var telefonoField: UILabel!
    @IBOutlet weak var emailField: UILabel!
    
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var emailArrow: UIImageView!
    @IBOutlet weak var telefonoArrow: UIImageView!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var apellidosArrow: UIImageView!
    
    var empleado: EmpleadoModel = EmpleadoModel()
    var updateMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Empleado"
        customizeBackground()
        customizeLabels()
        customizeFields()
        customizeArrows()
        addSaveEmpleadoButton()
        
        setValues()
    }
    
    func customizeBackground() {
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
        scrollContentView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeLabels() {
        nombreLabel.textColor = AppStyle.getSecondaryTextColor()
        apellidosLabel.textColor = AppStyle.getSecondaryTextColor()
        fechaLabel.textColor = AppStyle.getSecondaryTextColor()
        telefonoLabel.textColor = AppStyle.getSecondaryTextColor()
        emailLabel.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeFields() {
        informcaionLabel.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getPrimaryTextColor()
        apellidosField.textColor = AppStyle.getPrimaryTextColor()
        fechaField.textColor = AppStyle.getPrimaryTextColor()
        telefonoField.textColor = AppStyle.getPrimaryTextColor()
        emailField.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeArrows() {
        nombreArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        
        apellidosArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        apellidosArrow.tintColor = AppStyle.getSecondaryColor()
        
        fechaArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        fechaArrow.tintColor = AppStyle.getSecondaryColor()
        
        telefonoArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        telefonoArrow.tintColor = AppStyle.getSecondaryColor()
        
        emailArrow.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        emailArrow.tintColor = AppStyle.getSecondaryColor()
    }
    
    func addSaveEmpleadoButton() {
        var rightButtons: [UIBarButtonItem] = []
        rightButtons.append(UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton)))
        
        if empleado.empleadoId != 0 {
            rightButtons.append(UIBarButtonItem(image: UIImage(systemName: "phone"), style: .done, target: self, action: #selector(didClickCallEmpleadoButton)))
        }
        
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    func setValues() {
        nombreLabel.text = empleado.nombre
        apellidosLabel.text = empleado.apellidos
        if empleado.fecha != 0 {
            fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(empleado.fecha)))
        }
        
        telefonoLabel.text = empleado.telefono
        emailLabel.text = empleado.email
    }
    
    func showInputFieldView(inputReference: Int, keyBoardType: UIKeyboardType, text: String, controllerTitle: String) {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: FieldViewController = showItemStoryboard.instantiateViewController(withIdentifier: "FieldViewController") as! FieldViewController
        controller.inputReference = inputReference
        controller.delegate = self
        controller.keyboardType = keyBoardType
        controller.inputText = text
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openDatePickerView() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: DatePickerSelectorViewController = showItemStoryboard.instantiateViewController(withIdentifier: "DatePickerSelectorViewController") as! DatePickerSelectorViewController
        controller.delegate = self
        controller.datePickerMode = .date
        controller.initialDate = 0
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func checkFields() {
        if empleado.nombre.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir un nombre", viewController: self)
            return
        }
        
        if empleado.apellidos.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe escribir los apellidos del empleado", viewController: self)
            return
        }
        
        if empleado.fecha == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar una fecha de nacimiento", viewController: self)
            return
        }
        
        if telefonoLabel.text!.count < 9 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un número de contacto válido", viewController: self)
            return
        }
        
        if emailLabel.text!.count < 6 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir el e-mail del cliente", viewController: self)
            return
        }
        
        if !emailLabel.text!.contains("@") {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un e-mail válido", viewController: self)
            return
        }
        
        if empleado.redColorValue == 0 {
            setPredefinedColor()
        }
        
        if !updateMode {
            CommonFunctions.showLoadingStateView(descriptionText: "Guardando empleado")
            WebServices.addEmpleado(empleado: empleado, delegate: self)
        } else {
            CommonFunctions.showLoadingStateView(descriptionText: "Actualizando empleado")
            WebServices.updateEmpleado(empleado: empleado, delegate: self)
        }
    }
    
    func setPredefinedColor() {
        let components = UIColor.systemBlue.cgColor.components
        empleado.redColorValue = Float(components![0])
        empleado.greenColorValue = Float(components![1])
        empleado.blueColorValue = Float(components![2])
    }
}

extension AddEmpleadoViewController {
    @IBAction func didClickNombreField(_ sender: Any) {
        showInputFieldView(inputReference: 1, keyBoardType: .default, text: nombreLabel.text!, controllerTitle: "Nombre")
    }
    
    @IBAction func didClickApellidosField(_ sender: Any) {
        showInputFieldView(inputReference: 2, keyBoardType: .default, text: apellidosLabel.text!, controllerTitle: "Apellidos")
    }
    
    @IBAction func didClickFechaField(_ sender: Any) {
        openDatePickerView()
    }
    
    @objc func didClickSaveButton(sender: UIBarButtonItem) {
        checkFields()
    }
    
    @objc func didClickCallEmpleadoButton(sender: UIBarButtonItem) {
        CommonFunctions.callPhone(telefono: empleado.telefono.replacingOccurrences(of: " ", with: ""))
    }
    
    @IBAction func didClickTelefonoButton(_ sender: Any) {
        showInputFieldView(inputReference: 3, keyBoardType: .phonePad, text: telefonoLabel.text!, controllerTitle: "Telefono")
    }
    
    @IBAction func didClickEmailButton(_ sender: Any) {
        showInputFieldView(inputReference: 4, keyBoardType: .emailAddress, text: emailLabel.text!, controllerTitle: "Email")
    }
}

extension AddEmpleadoViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            empleado.nombre = text
            nombreLabel.text = text
        case 2:
            empleado.apellidos = text
            apellidosLabel.text = text
        case 3:
            empleado.telefono = text
            telefonoLabel.text = text
        default:
            empleado.email = text
            emailLabel.text = text
        }
    }
}

extension AddEmpleadoViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        empleado.fecha = Int64(date.timeIntervalSince1970)
        fechaLabel.text = CommonFunctions.getTimeTypeStringFromDate(date: date)
    }
}

extension AddEmpleadoViewController: AddEmpleadoProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successSavingEmpleado(empleado: EmpleadoModel) {
        Constants.databaseManager.empleadosManager.addEmpleadoToDatabase(newEmpleado: empleado)
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorSavingEmpleado() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando empleado", viewController: self)
        }
    }
}

extension AddEmpleadoViewController: UpdateEmpleadoProtocol {
    func successUpdatingEmpleado(empleado: EmpleadoModel) {
        Constants.databaseManager.empleadosManager.updateEmpleado(empleado: empleado)
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func errorUpdatingEmpleado() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando empleado", viewController: self)
        }
    }
}
