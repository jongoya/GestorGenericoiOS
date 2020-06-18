//
//  HemeTableViewCell.swift
//  GestorHeme
//
//  Created by jon mikel on 10/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class HemeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var descripcionLabel: UILabel!
    @IBOutlet weak var bodyContentView: UIView!
    
    func setupCell(hemeModel: HemeModel) {
        titleLabel.textColor = AppStyle.getPrimaryTextColor()
        descripcionLabel.textColor = AppStyle.getPrimaryTextColor()
        bodyContentView.backgroundColor = AppStyle.getBackgroundColor()
        
        cellContentView.layer.cornerRadius = 10
        titleLabel.text = hemeModel.titulo
        cellImageView.image = UIImage(named: hemeModel.nombreImagen)?.withRenderingMode(.alwaysTemplate)
        cellImageView.tintColor = AppStyle.getPrimaryTextColor()
        descripcionLabel.text = hemeModel.descripcion
    }
}
