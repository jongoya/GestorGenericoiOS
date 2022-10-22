//
//  NotificationDetailViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import MessageUI

class NotificationDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var notificationReasonLabel: UILabel!
    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var longDescriptionLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var notificationImage: UIImageView!
    
    var noticationDayModel: NotificationDayModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notificación"
        customizeImage()
        customizeLabels()
        customizeButtons()
        
        if !noticationDayModel.notificaciones[0].leido  {
            markNotificationAsRead()
        }
        
        setContentView()
        customizeButton(button: callButton)
        customizeButton(button: sendEmailButton)
        customizeButton(button: chatButton)
    }
    
    func customizeImage() {
        notificationImage.image = UIImage(named: "notification_cumple")!.withRenderingMode(.alwaysTemplate)
        notificationImage.tintColor = AppStyle.getPrimaryColor()
    }
    
    func customizeLabels() {
        notificationReasonLabel.textColor = AppStyle.getPrimaryTextColor()
        shortDescriptionLabel.textColor = AppStyle.getPrimaryTextColor()
        longDescriptionLabel.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeButtons() {
        let callImage: UIImage = UIImage(named: "telefono")!.withRenderingMode(.alwaysTemplate)
        callButton.setImage(callImage, for: .normal)
        callButton.tintColor = AppStyle.getPrimaryColor()
        
        let chatImage: UIImage = UIImage(named: "chat")!.withRenderingMode(.alwaysTemplate)
        chatButton.setImage(chatImage, for: .normal)
        chatButton.tintColor = AppStyle.getPrimaryColor()
        
        let messageImage: UIImage = UIImage(named: "correo")!.withRenderingMode(.alwaysTemplate)
        sendEmailButton.setImage(messageImage, for: .normal)
        sendEmailButton.tintColor = AppStyle.getPrimaryColor()
    }
    
    func markNotificationAsRead() {
        for notification: NotificationModel in noticationDayModel.notificaciones {
            notification.leido = true
        }
        
        CommonFunctions.showLoadingStateView(descriptionText: "Actualizando notificación")
        WebServices.updateNotifications(notifications: noticationDayModel.notificaciones, delegate: self)
    }
    
    func setContentView() {
        if noticationDayModel.notificaciones[0].type == Constants.notificacionCumpleIdentifier {
            backgroundImageView.image = UIImage(named: "confetti")
            notificationReasonLabel.text = "¡Cumpleaños!"
            shortDescriptionLabel.text = createBirthdayDescription()
            longDescriptionLabel.text = noticationDayModel.notificaciones[0].descripcion
        } else if noticationDayModel.notificaciones[0].type == Constants.notificacionPersonalizadaIdentifier {
            backgroundImageView.image = UIImage(named: "personalizada")
            notificationReasonLabel.text = "Notificación personalizada"
            shortDescriptionLabel.text = createNotificacionPersonalizadaDescription()
            longDescriptionLabel.text = noticationDayModel.notificaciones[0].descripcion
        }
    }
    
    func customizeButton(button: UIView) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = AppStyle.getSecondaryColor().cgColor
        button.backgroundColor = .white
    }
    
    func createBirthdayDescription() -> String {
        var text: String = ""
        
        for notification: NotificationModel in noticationDayModel.notificaciones {
            let client: ClientModel = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: notification.clientId)!
            text.append(client.nombre + " " + client.apellidos + ", ")
        }
        
        return text + (noticationDayModel.notificaciones.count > 1 ? "felicitalos!" : "felicitalo!")
    }
    
    func createNotificacionPersonalizadaDescription() -> String {
        let notification: NotificationModel = noticationDayModel.notificaciones[0]
        let year: Int = AgendaFunctions.getYearNumberFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        let month: String = AgendaFunctions.getMonthNameFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha))).capitalized
        let day: Int = Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        
        return String(day) + " de " + String(month) + " de " + String(year)
    }
    
    func showActionsheet(comunicationCase: Int) {
        let alert = UIAlertController(title: "Elige", message: "Debe elegir una de las opciones", preferredStyle: .actionSheet)
        for index in 0...noticationDayModel.notificaciones.count - 1 {
            alert.addAction(UIAlertAction(title: getNombreApellidosFromUser(clientId: noticationDayModel.notificaciones[index].clientId), style: .default , handler:{ (UIAlertAction) in
                self.openComunicationForCase(comunicationCase: comunicationCase, userPosition: index)
            }))
        }

        alert.addAction(UIAlertAction(title: "cancelar", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func getTelefonoFromUser(clientId: Int64) -> String {
        let client = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: clientId)!
        return client.telefono.replacingOccurrences(of: " ", with: "")
    }
    
    func getNombreApellidosFromUser(clientId: Int64) -> String {
        let client = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: clientId)!
        return client.nombre + " " + client.apellidos
    }
    
    func composeLetter(telefono: String) {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        composeVC.recipients = [telefono]

        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            CommonFunctions.showGenericAlertMessage(mensaje: "Este dispositivo no puede mandar mensajes", viewController: self)
        }
    }
    
    func openComunicationForCase(comunicationCase: Int, userPosition: Int) {
        switch comunicationCase {
        case 1:
            CommonFunctions.callPhone(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones[userPosition].clientId))
            break
        case 2:
            composeLetter(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones[userPosition].clientId))
            break
        default:
            CommonFunctions.openWhatsapp(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones[userPosition].clientId))
            break
        }
    }
}

extension NotificationDetailViewController {
    @IBAction func didClickCallButton(_ sender: Any) {
        if noticationDayModel.notificaciones.count > 1 {
            showActionsheet(comunicationCase: 1)
        } else {
            CommonFunctions.callPhone(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones.first!.clientId))
        }
    }
    
    @IBAction func didClickSendEmailButton(_ sender: Any) {
        if noticationDayModel.notificaciones.count > 1 {
            showActionsheet(comunicationCase: 2)
        } else {
            composeLetter(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones.first!.clientId))
        }
    }
    
    @IBAction func didClickChatButton(_ sender: Any) {
        if noticationDayModel.notificaciones.count > 1 {
            showActionsheet(comunicationCase: 3)
        } else {
            CommonFunctions.openWhatsapp(telefono: getTelefonoFromUser(clientId: noticationDayModel.notificaciones.first!.clientId))
        }
    }
}

extension NotificationDetailViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension NotificationDetailViewController: UpdateNotificationsProtocol {
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
    
    func successUpdatingNotifications(notifications: [NotificationModel]) {
        for notification: NotificationModel in notifications {
            Constants.databaseManager.notificationsManager.markNotificationAsRead(notification: notification)
        }
        
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            Constants.rootController.setNotificationBarItemBadge()
        }
    }
    
    func errorUpdatingNotifications() {
        DispatchQueue.main.async {
            CommonFunctions.hideLoadingStateView()
            CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando notificación", viewController: self)
        }
    }
}
