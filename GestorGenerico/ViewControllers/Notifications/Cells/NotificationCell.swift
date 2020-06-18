//
//  NotificationCell.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var notificationContentView: UIView!
    @IBOutlet weak var notificationImage: UIImageView!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var notificationDescriptionLabel: UILabel!
    @IBOutlet weak var wholeContentView: UIView!
    
    func setupCell(notificationModel: NotificationDayModel) {
        customizeContentView(notification: notificationModel.notificaciones[0])
        wholeContentView.backgroundColor = AppStyle.getBackgroundColor()
        
        if notificationModel.notificaciones[0].type == Constants.notificacionCumpleIdentifier {
            setBirthdayContent(notificationModel: notificationModel)
        } else if notificationModel.notificaciones[0].type == Constants.notificacionCajaCierreIdentifier {
            setCierreCajaContent(notificationModel: notificationModel)
        } else if notificationModel.notificaciones[0].type == Constants.notificacionCadenciaIdentifier {
            setCadenciacontent(notificationModel: notificationModel)
        } else if notificationModel.notificaciones[0].type == Constants.notificacionPersonalizadaIdentifier {
            setPersonalizadaContent(notificationModel: notificationModel)
        }
    }
    
    private func customizeContentView(notification: NotificationModel) {
        notificationContentView.layer.cornerRadius = 10
        notificationContentView.layer.borderWidth = 1
        if notification.leido {
            notificationImage.tintColor = AppStyle.getPrimaryTextColor()
            notificationContentView.layer.borderColor = AppStyle.getSecondaryColor().cgColor
        } else {
            notificationContentView.layer.borderColor = AppStyle.getPrimaryColor().cgColor
            notificationImage.tintColor = AppStyle.getPrimaryColor()
        }
    }
    
    private func setBirthdayContent(notificationModel: NotificationDayModel) {
        notificationImage.image = UIImage(named: "cumple")!.withRenderingMode(.alwaysTemplate)
        clientName.text = "¡Felicitaciones!"
        let nextText: String = notificationModel.notificaciones.count > 1 ? " personas, felicitalos!" : " persona, felicitalo!"
        notificationDescriptionLabel.text = "¡Hoy cumplen años " + String(notificationModel.notificaciones.count) +  nextText
    }
    
    private func setCierreCajaContent(notificationModel: NotificationDayModel) {
        notificationImage.image = UIImage(named: "cash")!.withRenderingMode(.alwaysTemplate)
        let notification: NotificationModel = notificationModel.notificaciones[0]
        
        let year: Int = AgendaFunctions.getYearNumberFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        let month: String = AgendaFunctions.getMonthNameFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha))).capitalized
        let day: Int = Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        
        clientName.text = String(day) + " de " + String(month) + " de " + String(year)
        notificationDescriptionLabel.text = "¡El cierre de caja está pendiente de realizar!"
    }
    
    private func setCadenciacontent(notificationModel: NotificationDayModel) {
        notificationImage.image = UIImage(named: "cadencia")!.withRenderingMode(.alwaysTemplate)
        clientName.text = "¡Cadencia!"
        var text: String = String(notificationModel.notificaciones.count)
        text.append(notificationModel.notificaciones.count > 1 ? " clientes llevan tiempo sin venir" : " cliente lleva tiempo sin venir")
        
        notificationDescriptionLabel.text = text
    }
    
    private func setPersonalizadaContent(notificationModel: NotificationDayModel) {
        notificationImage.image = UIImage(named: "campana")!.withRenderingMode(.alwaysTemplate)
        let notification: NotificationModel = notificationModel.notificaciones[0]
        let cliente: ClientModel = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: notification.clientId)!
        
        let year: Int = AgendaFunctions.getYearNumberFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        let month: String = AgendaFunctions.getMonthNameFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha))).capitalized
        let day: Int = Calendar.current.component(.day, from: Date(timeIntervalSince1970: TimeInterval(notification.fecha)))
        
        clientName.text = String(day) + " de " + String(month) + " de " + String(year)
        notificationDescriptionLabel.text = "Notificación de " + cliente.nombre + " " + cliente.apellidos
    }
}
