//
//  LoginViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginContentview: UIView!
    @IBOutlet weak var loginText: UILabel!
    @IBOutlet weak var loginBackground: UIImageView!
    @IBOutlet weak var iconoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:))))
        initializeTokenInSharedPreferences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkLoginStyle() {
            setLoginStyle()
        } else {
            getEstiloLogin()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func initializeTokenInSharedPreferences() {
        if !UserPreferences.checkValueInUserDefaults(key: Constants.preferencesTokenKey) {
            UserPreferences.saveValueInUserDefaults(value: "", key: Constants.preferencesTokenKey)
        }
    }
    
    private func getEstiloLogin() {
        CommonFunctions.showLoadingStateView(descriptionText: "Cargando estilo")
        WebServices.getEstiloLogin(bundleId: CommonFunctions.getBundleId().replacingOccurrences(of: ".", with: "_"), delegate: self)
    }
    
    private func checkLoginStyle() -> Bool {
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginIconoKey)) {
            return true
        }
        
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginBackgroundKey)) {
            return true
        }
        
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryColorKey)) {
            return true
        }
        
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryTextColorKey)) {
            return true
        }
        
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginSecondaryTextColorKey)) {
            return true
        }
        
        return false
    }
    
    private func setLoginStyle() {
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginBackgroundKey)) {
            let background: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginBackgroundKey) as! String
            setImageWithString(stringData: background, imageView: loginBackground)
        }
        
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginIconoKey)) {
            let icono: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginIconoKey) as! String
            setImageWithString(stringData: icono, imageView: iconoImage)
        }
        
        let primaryTextColor: String = AppStyle.getLoginPrimaryTextColor()
        let secondaryTextColor: String = AppStyle.getLoginSecondaryTextColor()
        let primaryColor: String = AppStyle.getLoginPrimaryColor()
        
        customizeTextFieldWithValues(primaryColor: primaryColor, secondaryTextColor: secondaryTextColor, primaryTextColor: primaryTextColor, textField: userField, placeHolderText: "Usuario")
        customizeTextFieldWithValues(primaryColor: primaryTextColor, secondaryTextColor: secondaryTextColor, primaryTextColor: primaryTextColor, textField: passwordField, placeHolderText: "Contraseña")
        customizeLoginButton(primaryColor: primaryColor, primaryTextColor: primaryTextColor)
    }
    
    private func saveLoginStyle(estiloLogin: EstiloLoginModel) {
        if estiloLogin.fondoLogin != nil && estiloLogin.fondoLogin!.count > 0 {
            UserPreferences.saveValueInUserDefaults(value: estiloLogin.fondoLogin!, key: Constants.preferencesLoginBackgroundKey)
        }
        
        if (estiloLogin.primaryColor != nil && estiloLogin.primaryColor!.count > 0) {
            UserPreferences.saveValueInUserDefaults(value: estiloLogin.primaryColor!, key: Constants.preferencesLoginPrimaryColorKey)
        }
        
        if (estiloLogin.primaryTextColor != nil && estiloLogin.primaryTextColor!.count > 0) {
            UserPreferences.saveValueInUserDefaults(value: estiloLogin.primaryTextColor!, key: Constants.preferencesLoginPrimaryTextColorKey)
        }
        
        if (estiloLogin.secondaryTextColor != nil && estiloLogin.secondaryTextColor!.count > 0) {
            UserPreferences.saveValueInUserDefaults(value: estiloLogin.secondaryTextColor!, key: Constants.preferencesLoginSecondaryTextColorKey)
        }
        
        if (estiloLogin.iconoApp != nil && estiloLogin.iconoApp!.count > 0) {
            UserPreferences.saveValueInUserDefaults(value: estiloLogin.iconoApp!, key: Constants.preferencesLoginIconoKey)
        }
        
        UserPreferences.saveValueInUserDefaults(value: estiloLogin.nombreApp, key: Constants.preferencesLoginNombreAppKey)
    }
    
    private func setImageWithString(stringData: String, imageView: UIImageView) {
        let dataDecoded : Data = Data(base64Encoded: stringData, options: .ignoreUnknownCharacters)!
        imageView.image = UIImage(data: dataDecoded)
    }
    
    private func customizeTextFieldWithValues(primaryColor: String, secondaryTextColor: String, primaryTextColor: String, textField: UITextField, placeHolderText: String) {
        textField.layer.borderColor = CommonFunctions.hexStringToUIColor(hex: primaryColor).cgColor
        textField.layer.borderWidth = AppStyle.defaultBorderWidth
        textField.backgroundColor = .white
        textField.layer.cornerRadius = AppStyle.defaultCornerRadius
        textField.textColor = CommonFunctions.hexStringToUIColor(hex: primaryTextColor)
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: CommonFunctions.hexStringToUIColor(hex: secondaryTextColor)])
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.rightView = indentView
        textField.rightViewMode = .always
    }
    
    private func customizeLoginButton(primaryColor: String, primaryTextColor: String) {
        loginContentview.layer.cornerRadius = AppStyle.defaultCornerRadius
        loginContentview.layer.borderWidth = AppStyle.defaultBorderWidth
        loginContentview.layer.borderColor = CommonFunctions.hexStringToUIColor(hex: primaryColor).cgColor
        loginText.textColor = CommonFunctions.hexStringToUIColor(hex: primaryTextColor)
    }
    
    private func saveLoginDataAndChangeController(loginCompleto: LoginMasDispositivosModel) {
        UserPreferences.saveValueInUserDefaults(value: loginCompleto.login.password, key: Constants.preferencesPasswordKey)
        UserPreferences.saveValueInUserDefaults(value: loginCompleto.login.token, key: Constants.preferencesTokenKey)
        UserPreferences.saveValueInUserDefaults(value: loginCompleto.login.comercioId, key: Constants.preferencesComercioIdKey)
        Constants.databaseManager.estiloAppManager.addEstiloToDatabase(estilo: loginCompleto.estiloApp)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        let sceneDelegate: SceneDelegate = self.view.window!.windowScene!.delegate as! SceneDelegate
        sceneDelegate.window!.rootViewController = vc
    }
    
    private func showTooMuchDevicesMessage(loginMasDispositivosModel: LoginMasDispositivosModel) {
        let alert = UIAlertController(title: "Ha llegado al límite de dispositivos conectados", message: "¿Desea des-registrar un dispositivo para conectar el actual?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action) in
            self.showDeviceDialog(loginMasDispositivosModel: loginMasDispositivosModel)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeviceDialog(loginMasDispositivosModel: LoginMasDispositivosModel) {
        let alert = UIAlertController(title: "Dispositivos", message: "Seleccione el dispositivo a eliminar", preferredStyle: UIAlertController.Style.actionSheet)
        for dispositivo: DispositivoModel in loginMasDispositivosModel.dispositivos {
            alert.addAction(UIAlertAction(title: dispositivo.nombre_dispositivo, style: .default, handler: { (_) in
                let loginMasDispositivos = LoginMasDispositivosModel(login: loginMasDispositivosModel.login, dispositivos: [dispositivo])
                CommonFunctions.showLoadingStateView(descriptionText: "Iniciando sesión")
                WebServices.registerAndUnregisterDevices(loginMasDispositivos: loginMasDispositivos, delegate: self)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        userField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    @IBAction func didClickLoginButton(_ sender: Any) {
        CommonFunctions.showLoadingStateView(descriptionText: "Iniciando sesión")
        let nombreApp: String = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginNombreAppKey) as! String
        let login: LoginModel = LoginModel(usuario: userField.text!, password: passwordField.text!, nombre: nombreApp, nombreDispositivo: UIDevice.modelName, uniqueDeviceId: CommonFunctions.getUniqueDeviceId())
        WebServices.login(login: login, delegate: self)
    }
}

extension LoginViewController: LoginProtocol {
    func successGettingLoginStyle(estiloLogin: EstiloLoginModel) {
        saveLoginStyle(estiloLogin: estiloLogin)
        CommonFunctions.hideLoadingStateView()
        setLoginStyle()
    }
    
    func errorGettingLoginStyle() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error cargando estilo login", viewController: self)
    }
    
    func succesLogingIn(loginCompleto: LoginMasDispositivosModel) {
        CommonFunctions.hideLoadingStateView()
        saveLoginDataAndChangeController(loginCompleto: loginCompleto)
        CommonFunctions.sincronizarBaseDeDatos()
    }
    
    func errorLoginIn() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error iniciando sesion, inténtelo de nuevo", viewController: self)
    }
    
    func tooMuchDevicesLogingIn(loginMasDispositivosModel: LoginMasDispositivosModel) {
        CommonFunctions.hideLoadingStateView()
        showTooMuchDevicesMessage(loginMasDispositivosModel: loginMasDispositivosModel)
    }
}
