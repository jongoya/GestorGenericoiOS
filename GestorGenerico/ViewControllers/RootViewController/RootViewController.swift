//
//  ViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 31/03/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import MessageUI

class RootViewController: UITabBarController {
    @IBOutlet weak var rigthNavigationButton: UIBarButtonItem!
    @IBOutlet weak var secondRightNavigationButton: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Clientes"
        self.delegate = self
        customizeTabBar()
        customizeNavBar()
        Constants.rootController = self
        setNotificationBarItemBadge()
    }
    
    func customizeTabBar() {
        tabBar.tintColor =  AppStyle.getPrimaryColor()
        tabBar.layer.borderColor =  AppStyle.getSecondaryColor().cgColor
        tabBar.unselectedItemTintColor = AppStyle.getPrimaryTextColor()
        tabBar.items![3].title = AppStyle.getAppName()
        tabBar.barTintColor = AppStyle.getNavigationColor()
        //TODO
        //tabBar.items![0].image == Modificar la imagen
    }
    
    func customizeNavBar() {
        navigationController!.navigationBar.barTintColor = AppStyle.getNavigationColor()
        navigationController!.navigationBar.tintColor = AppStyle.getPrimaryColor()
        navigationController!.navigationBar.titleTextAttributes = [.foregroundColor: AppStyle.getPrimaryTextColor()]
    }
    
    func updateControllerForStyleUpdate() {
        selectedViewController?.viewWillAppear(true)
    }
    
    func setNotificationBarItemBadge() {
        let notifications: [NotificationModel] =  Constants.databaseManager.notificationsManager.getAllNotificationsFromDatabase()
        var notificationesNoLeidas: Int = 0
        for notification in notifications {
            if !notification.leido {
                notificationesNoLeidas = notificationesNoLeidas + 1
            }
        }
        
        if notificationesNoLeidas > 0 {
            tabBar.items![2].badgeValue = String(notificationesNoLeidas)
        } else {
            tabBar.items![2].badgeValue = nil
        }
    }
    
    func openSettingsViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Settings", bundle:nil)
        let controller: SettingsViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func fillSecondRightNavigationButtonImage() {
        secondRightNavigationButton.image = UIImage(systemName: "person.fill")
    }
    
    func unfillSecondRightNavigationButtonImage() {
        secondRightNavigationButton.image = UIImage(systemName: "person")
    }
    
    private func openProductScanner() {
        let scannerViewController: ScannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true, completion: nil)
    }
    
    func openVentaProductoViewController(producto: ProductoModel) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Productos", bundle:nil)
        let controller: VentaProductoViewController = storyBoard.instantiateViewController(withIdentifier: "ventaProducto") as! VentaProductoViewController
        controller.ventas.append(VentaModel(productoId: producto.productoId))
        self.navigationController!.pushViewController(controller, animated: true)
    }
}


//Click actions
extension RootViewController {
    @IBAction func didClickRightNavigationButton(_ sender: Any) {
        if selectedIndex == 0 {//Clients tab
            performSegue(withIdentifier: "AddClientIdentifier", sender: nil)
        } else if selectedIndex == 3 {
            openSettingsViewController()
        } else if selectedIndex == 1 {
            let controller: AgendaViewController =  selectedViewController as! AgendaViewController
            controller.didClickCalendarButton()
        }
    }
    
    @IBAction func didClickSecondRightButton(_ sender: Any) {
        if selectedIndex == 1 {
            let controller: AgendaViewController =  selectedViewController as! AgendaViewController
            controller.didClickListarClientes()
        }
    }
    
    @IBAction func didClickLeftBarButton(_ sender: Any) {
        openProductScanner()
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            title = "Clientes"
            leftBarButtonItem.image = UIImage(named: "")
            rigthNavigationButton.image = UIImage(systemName: "plus")
            secondRightNavigationButton.image = UIImage(named: "")
        case 1:
            title = "Agenda"
            leftBarButtonItem.image = UIImage(systemName: "barcode")
            rigthNavigationButton.image = UIImage(systemName: "calendar")
            secondRightNavigationButton.image = UIImage(systemName: "person")
        case 2:
            title = "Notificaciones"
            leftBarButtonItem.image = UIImage(named: "")
            rigthNavigationButton.image = UIImage(named: "")
            secondRightNavigationButton.image = UIImage(named: "")
        default:
            title = "Heme"
            leftBarButtonItem.image = UIImage(named: "")
            rigthNavigationButton.image = UIImage(systemName: "wrench.fill")
            secondRightNavigationButton.image = UIImage(named: "")
        }
    }
}

extension RootViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if error == nil  && result == .sent {
            UserPreferences.saveValueInUserDefaults(value: Int64(Date().timeIntervalSince1970), key: Constants.backupKey)
        }
    }
}

extension RootViewController: ProductoScannerProtocol {
    func codigoBarrasDetected(codigoBarras: String) {
        let producto: ProductoModel? = Constants.databaseManager.productosManager.getProductWithBarcode(barcode: codigoBarras)
        if producto == nil {
            CommonFunctions.showGenericAlertMessage(mensaje: "El producto no se encuentra en stock", viewController: selectedViewController!)
            return
        }
        
        if producto!.numProductos == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Este producto está agotado", viewController: selectedViewController!)
            return
        }
        
        openVentaProductoViewController(producto: producto!)
    }
    
    func errorDetectingCodigoBarras() {
        CommonFunctions.showGenericAlertMessage(mensaje: "No se ha podido leer el codigo de barras", viewController: selectedViewController!)
    }
}
