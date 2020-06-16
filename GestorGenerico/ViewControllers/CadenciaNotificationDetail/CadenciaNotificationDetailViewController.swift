//
//  CadenciaNotificationDetailViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 24/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class CadenciaNotificationDetailViewController: UIViewController {
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var cadenciaTextLabel: UILabel!
    @IBOutlet weak var clientTableView: UITableView!
    
    var notificationDayModel: NotificationDayModel!
    var clientes: [ClientModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detalle"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClientes()
        setCadenciaLabel()
        
        if !notificationDayModel.notificaciones[0].leido {
            markNotificationAsRead()
        }
    }
    
    func setCadenciaLabel() {
        cadenciaTextLabel.text = notificationDayModel.notificaciones.count > 1 ? "Hay " + String(notificationDayModel.notificaciones.count) + " clientes que llevan tiémpo sin venir" : "Hay 1 Cliente que lleva tiémpo sin venir"
    }
    
    func getClientes() {
        for notification: NotificationModel in notificationDayModel.notificaciones {
            clientes.append(Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: notification.clientId)!)
        }
        
        clientTableView.reloadData()
    }
    
    func markNotificationAsRead() {
        for notification: NotificationModel in notificationDayModel.notificaciones {
            notification.leido = true
        }
        
        CommonFunctions.showLoadingStateView(descriptionText: "Actualizando notificación")
        WebServices.updateNotifications(notifications: notificationDayModel.notificaciones, delegate: self)
    }
}

extension CadenciaNotificationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clientes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CadenciaNotificationCell = tableView.dequeueReusableCell(withIdentifier: "CadenciaNotificationCell", for: indexPath) as! CadenciaNotificationCell
        cell.selectionStyle = .none
        cell.setupCell(client: clientes[indexPath.row])
        return cell
    }
}

extension CadenciaNotificationDetailViewController: UpdateNotificationsProtocol {
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
