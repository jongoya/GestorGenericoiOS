//
//  ProductoView.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ProductoView: UIView {
    var imageView: UIImageView!
    var nombreLabel: UILabel!
    var precioLabel: UILabel!
    var cantidadLabel: UILabel!
    var divisory: UIView!
    var button: UIButton!
    
    var position: Int!
    var delegate: ProductoViewProtocol!

    init(venta: VentaModel, position: Int, isLastProduct: Bool, delegate: ProductoViewProtocol, enableClick: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        self.position = position
        self.delegate = delegate
        let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
        addImageView(imagen: producto.imagen)
        addProducName(nombre: producto.nombre)
        addPrecio(precio: producto.precio)
        addCantidad(cantidad: venta.cantidad)
        
        if !isLastProduct {
            addDivisory()
        }
        
        if enableClick {
            addButton()
        }
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addImageView(imagen: String) {
        let dataDecoded : Data = Data(base64Encoded: imagen, options: .ignoreUnknownCharacters)!
        imageView = UIImageView(image: UIImage(data: dataDecoded))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.layer.cornerRadius = 30
    }
    
    func addProducName(nombre: String) {
        nombreLabel = UILabel()
        nombreLabel.text = nombre
        nombreLabel.numberOfLines = 1
        nombreLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nombreLabel.textColor = AppStyle.getPrimaryTextColor()
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nombreLabel)
    }
    
    func addPrecio(precio: Double) {
        precioLabel = UILabel()
        precioLabel.text = "Precio: " + String(format: "%.2f", precio) + " €"
        precioLabel.textColor = AppStyle.getSecondaryTextColor()
        precioLabel.font = .systemFont(ofSize: 14)
        precioLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(precioLabel)
    }
    
    func addCantidad(cantidad: Int) {
        cantidadLabel = UILabel()
        cantidadLabel.text = "Cantidad: " + String(cantidad)
        cantidadLabel.font = .systemFont(ofSize: 14)
        cantidadLabel.textColor = AppStyle.getPrimaryTextColor()
        cantidadLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cantidadLabel)
    }
    
    func addDivisory() {
        divisory = UIView()
        divisory.backgroundColor = AppStyle.getSecondaryColor()
        divisory.translatesAutoresizingMaskIntoConstraints = false
        addSubview(divisory)
    }
    
    func addButton() {
        button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didClickButton), for: .touchUpInside)
        addSubview(button)
    }
    
    
    func setConstraints() {
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        nombreLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        nombreLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        
        precioLabel.topAnchor.constraint(equalTo: nombreLabel.bottomAnchor, constant: 2).isActive = true
        precioLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        
        cantidadLabel.topAnchor.constraint(equalTo: precioLabel.bottomAnchor, constant: 2).isActive = true
        cantidadLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        
        if divisory != nil {
            divisory.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
            divisory.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            divisory.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            divisory.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
        if button != nil {
            button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
}

extension ProductoView {
    @objc func didClickButton() {
        delegate.ventaClicked(ventaPosition: position)
    }
}
