//
//  ProductoTableViewCell.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ProductoTableViewCell: UITableViewCell {
    @IBOutlet weak var imagenProducto: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var numeroProductos: UILabel!
    
    func setupCell(producto: ProductoModel) {
        nombre.textColor = AppStyle.getPrimaryTextColor()
        numeroProductos.textColor = AppStyle.getSecondaryTextColor()
        
        nombre.text = producto.nombre
        numeroProductos.text = "Cantidad en Stock: " + String(producto.numProductos)
        
        if producto.imagen.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: producto.imagen, options: .ignoreUnknownCharacters)!
            imagenProducto.image = UIImage(data: dataDecoded)
            imagenProducto.layer.cornerRadius = 30
            imagenProducto.contentMode = .scaleAspectFill
        } else {
            imagenProducto.image = UIImage(named: "stock")?.withRenderingMode(.alwaysTemplate)
            imagenProducto.tintColor = AppStyle.getPrimaryTextColor()
            imagenProducto.layer.cornerRadius = 0
            imagenProducto.contentMode = .scaleAspectFit
        }
    }
}
