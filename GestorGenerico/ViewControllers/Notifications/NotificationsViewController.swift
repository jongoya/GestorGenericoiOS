//
//  NotificationsViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var cumpleView: UIView!
    @IBOutlet weak var cumpleLabel: UILabel!
    @IBOutlet weak var cadenciaView: UIView!
    @IBOutlet weak var cadenciaLabel: UILabel!
    @IBOutlet weak var facturacionView: UIView!
    @IBOutlet weak var facturacionLabel: UILabel!
    @IBOutlet weak var personalizadaLabel: UILabel!
    @IBOutlet weak var personalizadaView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var tableSeparatorView: UIView!
    
    var allNotifications: [NotificationModel] = []
    var todayNotifications: [NotificationModel] = []
    var oldNotifications: [NotificationModel] = []
    var groupedTodayNotifications: [NotificationDayModel] = []
    var groupedOldNotifications: [NotificationDayModel] = []
    var emptyStateLabel: UILabel!
    var tableRefreshControl: UIRefreshControl = UIRefreshControl()
    
    var tapSelected: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didClickcumpleButton("")
        addRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeTableView()
        customizeButtonsContainer()
        showNotifications()
        
        DispatchQueue.global().async {
            NotificationFunctions.checkAllNotifications()
        }
    }
    
    func customizeButtonsContainer() {
        buttonsContainer.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeTableView() {
        notificationsTableView.backgroundColor = AppStyle.getBackgroundColor()
        tableSeparatorView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func showNotifications() {
        todayNotifications.removeAll()
        oldNotifications.removeAll()
        groupedTodayNotifications.removeAll()
        groupedOldNotifications.removeAll()
        if emptyStateLabel != nil {
            emptyStateLabel.removeFromSuperview()
            emptyStateLabel = nil
        }
        allNotifications = Constants.databaseManager.notificationsManager.getAllNotificationsForType(type: getNotificationType())
        
        if allNotifications.count > 0 {
            filterNotifications()
            groupNotificaitons()
        } else {
            emptyStateLabel = CommonFunctions.createEmptyState(emptyText: "No hay notificaciones disponibles", parentView: self.view)
        }
        
        notificationsTableView.reloadData()
    }
    
    func addRefreshControl() {
        tableRefreshControl.addTarget(self, action: #selector(refreshNotifications), for: .valueChanged)
        notificationsTableView.refreshControl = tableRefreshControl
    }
    
    func filterNotifications() {
        let begginingOfDay: Int64 = Int64(NotificationFunctions.getBeginningOfDayFromDate(date: Date()).timeIntervalSince1970)
        let endDayOfDay: Int64 = Int64(NotificationFunctions.getEndOfDayFromDate(date: Date()).timeIntervalSince1970)
        
        for notification: NotificationModel in allNotifications {
            if notification.fecha > begginingOfDay && notification.fecha < endDayOfDay {
                todayNotifications.append(notification)
            } else {
                oldNotifications.append(notification)
            }
        }
    }
    
    func groupNotificaitons() {
        switch tapSelected {
        case 1:
            groupNotificationsPerDay(isOldNotifications: false)
            groupNotificationsPerDay(isOldNotifications: true)
        case 2:
            groupNotificationsPerDay(isOldNotifications: false)
            groupNotificationsPerDay(isOldNotifications: true)
        case 3:
            createIndividualNotifications()
        default:
            createIndividualNotifications()
        }
    }
    
    func groupNotificationsPerDay(isOldNotifications: Bool) {
        var fechas: [Int64] = []
        var notificacionesAgrupadas: [NotificationDayModel] = []
        let notifications: [NotificationModel] = isOldNotifications ? oldNotifications : todayNotifications
        for notification: NotificationModel in notifications {
            let begininOfDay: Int64 = Int64(AgendaFunctions.getBeginningOfDayFromDate(date: Date(timeIntervalSince1970: TimeInterval(notification.fecha))).timeIntervalSince1970)
            if !fechas.contains(begininOfDay) {
                fechas.append(begininOfDay)
                notificacionesAgrupadas.append(NotificationDayModel(fecha: notification.fecha, notificaciones: []))
            }
        }
        
        for model: NotificationDayModel in notificacionesAgrupadas {
            let begininOfDay: Int64 = Int64(AgendaFunctions.getBeginningOfDayFromDate(date: Date(timeIntervalSince1970: TimeInterval(model.fecha))).timeIntervalSince1970)
            let endOfDay: Int64 = Int64(AgendaFunctions.getEndOfDayFromDate(date: Date(timeIntervalSince1970: TimeInterval(model.fecha))).timeIntervalSince1970)
            for notification: NotificationModel in notifications {
                if notification.fecha > begininOfDay && notification.fecha < endOfDay {
                    model.notificaciones.append(notification)
                }
            }
        }
        
        if isOldNotifications {
            groupedOldNotifications = notificacionesAgrupadas
        } else {
            groupedTodayNotifications = notificacionesAgrupadas
        }
    }
    
    func createIndividualNotifications() {
        for notification: NotificationModel in todayNotifications {
            let notificationModel: NotificationDayModel = NotificationDayModel(fecha: notification.fecha, notificaciones: [notification])
            groupedTodayNotifications.append(notificationModel)
        }
        
        for notification: NotificationModel in oldNotifications {
            let notificationModel: NotificationDayModel = NotificationDayModel(fecha: notification.fecha, notificaciones: [notification])
            groupedOldNotifications.append(notificationModel)
        }
    }
    
    func getNotificationModelForIndexPath(indexPath: IndexPath) -> NotificationDayModel {
        if indexPath.section == 0 && groupedTodayNotifications.count > 0 {
            return groupedTodayNotifications[indexPath.row]
        }
        
        return groupedOldNotifications[indexPath.row]
    }
    
    func paintWholeButton(view: UIView, label: UILabel) {
        view.backgroundColor = AppStyle.getPrimaryColor()
        view.layer.borderWidth = 1
        view.layer.borderColor = AppStyle.getPrimaryColor().cgColor
        view.layer.cornerRadius = 10
        label.textColor = .white
    }
    
    func paintBorderButton(view: UIView, label: UILabel) {
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = AppStyle.getPrimaryColor().cgColor
        view.layer.cornerRadius = 10
        label.textColor = AppStyle.getPrimaryColor()
    }
    
    func getNotificationType() -> String {
        switch tapSelected {
        case 1:
            return Constants.notificacionCumpleIdentifier
        case 2:
            return Constants.notificacionCadenciaIdentifier
        case 3:
            return Constants.notificacionCajaCierreIdentifier
        default:
            return Constants.notificacionPersonalizadaIdentifier
        }
    }
    
    func openBirthdayDetail(notificationDayModel: NotificationDayModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
        let controller: NotificationDetailViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
        controller.noticationDayModel = notificationDayModel
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openCierreCaja(notificacion: NotificationModel) {
        if notificacion.leido {
            CommonFunctions.showGenericAlertMessage(mensaje: "Cierre caja realizado en la fecha indicada", viewController: self)
            return
        }
        
        performSegue(withIdentifier: "cierreCajaIdentifier", sender: notificacion)
    }
    
    func openCadenciaDetail(notificationDayModel: NotificationDayModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Notification", bundle:nil)
        let controller: CadenciaNotificationDetailViewController = storyBoard.instantiateViewController(withIdentifier: "CadenciaNotificationDetailViewController") as! CadenciaNotificationDetailViewController
        controller.notificationDayModel = notificationDayModel
        self.navigationController!.pushViewController(controller, animated: true)
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && todayNotifications.count > 0 {
            return groupedTodayNotifications.count
        } else {
            return groupedOldNotifications.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        if groupedTodayNotifications.count > 0 {
            numberOfSections = numberOfSections + 1
        }
        
        if groupedOldNotifications.count > 0 {
            numberOfSections = numberOfSections + 1
        }
        
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationCell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.selectionStyle = .none
        cell.setupCell(notificationModel: getNotificationModelForIndexPath(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tapSelected {
        case 1:
            openBirthdayDetail(notificationDayModel: getNotificationModelForIndexPath(indexPath: indexPath))
            break
        case 2:
            openCadenciaDetail(notificationDayModel: getNotificationModelForIndexPath(indexPath: indexPath))
            break
        case 3:
            openCierreCaja(notificacion: getNotificationModelForIndexPath(indexPath: indexPath).notificaciones[0])
            break
        default:
            openBirthdayDetail(notificationDayModel: getNotificationModelForIndexPath(indexPath: indexPath))
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0  && groupedTodayNotifications.count > 0 {
            return "Hoy"
        } else {
            return "Antiguas"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let view: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        view.tintColor = AppStyle.getBackgroundColor()
        view.textLabel!.textColor = AppStyle.getPrimaryTextColor()
    }
}

extension NotificationsViewController {
    @IBAction func didClickcumpleButton(_ sender: Any) {
        paintWholeButton(view: cumpleView, label: cumpleLabel)
        paintBorderButton(view: cadenciaView, label: cadenciaLabel)
        paintBorderButton(view: facturacionView, label: facturacionLabel)
        paintBorderButton(view: personalizadaView, label: personalizadaLabel)
        tapSelected = 1
        showNotifications()
    }
    
    @IBAction func didClickCadenciaButton(_ sender: Any) {
        paintWholeButton(view: cadenciaView, label: cadenciaLabel)
        paintBorderButton(view: cumpleView, label: cumpleLabel)
        paintBorderButton(view: facturacionView, label: facturacionLabel)
        paintBorderButton(view: personalizadaView, label: personalizadaLabel)
        tapSelected = 2
        showNotifications()
    }
    
    @IBAction func didClickFacturacionButton(_ sender: Any) {
        paintWholeButton(view: facturacionView, label: facturacionLabel)
        paintBorderButton(view: cumpleView, label: cumpleLabel)
        paintBorderButton(view: cadenciaView, label: cadenciaLabel)
        paintBorderButton(view: personalizadaView, label: personalizadaLabel)
        tapSelected = 3
        showNotifications()
    }
    
    @IBAction func didClickPersonalizada(_ sender: Any) {
        paintWholeButton(view: personalizadaView, label: personalizadaLabel)
        paintBorderButton(view: cumpleView, label: cumpleLabel)
        paintBorderButton(view: cadenciaView, label: cadenciaLabel)
        paintBorderButton(view: facturacionView, label: facturacionLabel)
        tapSelected = 4
        showNotifications()
    }
    
    @objc func refreshNotifications() {
        WebServices.getNotificaciones(comercioId: UserPreferences.getValueFromUserDefaults(key: Constants.preferencesComercioIdKey) as! Int64, delegate: self)
    }
}

extension NotificationsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cierreCajaIdentifier" {
            let notification: NotificationModel = sender as! NotificationModel
            let controller: CierreCajaViewController = segue.destination as! CierreCajaViewController
            controller.presentDate = Date(timeIntervalSince1970: TimeInterval(notification.fecha))
            controller.notification = notification
        }
    }
}

extension NotificationsViewController: GetNotificacionesProtocol {
    func successGettingNotificaciones() {
        DispatchQueue.main.async {
            self.tableRefreshControl.endRefreshing()
            self.showNotifications()
            Constants.rootController.setNotificationBarItemBadge()
        }
    }
    
    func errorGettingNotificaciones() {
        DispatchQueue.main.async {
            CommonFunctions.showGenericAlertMessage(mensaje: "Error cargando notificaciones", viewController: self)
        }
    }
}
