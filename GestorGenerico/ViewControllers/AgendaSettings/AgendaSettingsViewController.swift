//
//  AgendaSettingsViewController.swift
//  GestorHeme
//
//  Created by jon mikel on 11/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class AgendaSettingsViewController: UIViewController {
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var colorImage: UIImageView!
    @IBOutlet weak var colorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackgroundColor()
        customizeColorContentView()
        title = "Agenda"
    }
    
    func customizeBackgroundColor() {
        background.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func customizeColorContentView() {
        colorLabel.textColor = AppStyle.getPrimaryTextColor()
        colorImage.image = UIImage(named: "pincel")!.withRenderingMode(.alwaysTemplate)
        colorImage.tintColor = AppStyle.getPrimaryTextColor()
        
        contentView.layer.cornerRadius = 10
    }
}

extension AgendaSettingsViewController {
    @IBAction func didClickColoresButton(_ sender: Any) {
        performSegue(withIdentifier: "EmpleadosViewIdentifier", sender: nil)
    }
}

extension AgendaSettingsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmpleadosViewIdentifier" {
            let controller: EmpleadosViewController = segue.destination as! EmpleadosViewController
            controller.showColorView = true
        }
    }
}
