//
//  SettingsViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 10/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var empleadosView: UIView!
    @IBOutlet weak var serviciosView: UIView!
    @IBOutlet weak var agendaView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var agendaImage: UIImageView!
    @IBOutlet weak var serviciosImage: UIImageView!
    @IBOutlet weak var empleadosImage: UIImageView!
    
    @IBOutlet weak var empleadosLabel: UILabel!
    @IBOutlet weak var serviciosLabel: UILabel!
    @IBOutlet weak var agendaLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ajustes"
        customizeBackground()
        customizeLabels()
        customizeImages()
        customizeViews()
    }
    
    func customizeBackground() {
        backgroundView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeLabels() {
        empleadosLabel.textColor = AppStyle.getPrimaryTextColor()
        serviciosLabel.textColor = AppStyle.getPrimaryTextColor()
        agendaLabel.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeImages() {
        empleadosImage.image = UIImage(named: "empleado")!.withRenderingMode(.alwaysTemplate)
        empleadosImage.tintColor = AppStyle.getPrimaryTextColor()
        
        serviciosImage.image = UIImage(named: "servicio")!.withRenderingMode(.alwaysTemplate)
        serviciosImage.tintColor = AppStyle.getPrimaryTextColor()
        
        agendaImage.image = UIImage(systemName: "calendar")!.withRenderingMode(.alwaysTemplate)
        agendaImage.tintColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeViews() {
        empleadosView.layer.cornerRadius = 10
        agendaView.layer.cornerRadius = 10
        serviciosView.layer.cornerRadius = 10
    }
}

extension SettingsViewController {
    @IBAction func didClickEmpleados(_ sender: Any) {
        performSegue(withIdentifier: "EmpleadosViewIdentifier", sender: nil)
    }
    
    @IBAction func didClickServicios(_ sender: Any) {
        performSegue(withIdentifier: "ServiciosIdentifier", sender: nil)
    }
    
    @IBAction func didClickCalendar(_ sender: Any) {
        performSegue(withIdentifier: "AgendaSettingsIdentifier", sender: nil)
    }
}

extension SettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmpleadosViewIdentifier" {
            let controller: EmpleadosViewController = segue.destination as! EmpleadosViewController
            controller.showColorView = false
        }
    }
}
