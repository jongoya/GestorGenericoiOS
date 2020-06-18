//
//  ServicioTableViewCell.swift
//  GestorHeme
//
//  Created by jon mikel on 13/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ServicioTableViewCell: UITableViewCell {
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var nombreServicioLabel: UILabel!
    @IBOutlet weak var bodyContentView: UIView!
    @IBOutlet weak var servicioImage: UIImageView!
    
    func setupCell(servicio: TipoServicioModel) {
        bodyContentView.backgroundColor = AppStyle.getBackgroundColor()
        nombreServicioLabel.textColor = AppStyle.getPrimaryTextColor()
        servicioImage.image = UIImage(named: "servicio")!.withRenderingMode(.alwaysTemplate)
        servicioImage.tintColor = AppStyle.getPrimaryTextColor()
        
        cellContentView.layer.cornerRadius = 10
        nombreServicioLabel.text = servicio.nombre
    }
}
