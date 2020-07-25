//
//  ServicioView.swift
//  GestorHeme
//
//  Created by jon mikel on 03/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ServicioView: UIView {
    let defaultMargin: CGFloat = 10
    let fieldWidth: CGFloat = 135
    let fieldHeigth: CGFloat = 50
    let observacionesTopMargin: CGFloat = 20
    
    var titleLabel: UILabel = UILabel()
    var observacionesLabel: UILabel!
    
    var servicio: ServiceModel!
    var cesta: CestaModel!
    var fieldArray: [UIView] = []
    var delegate: ServicioViewProtocol!
    
    init(service: ServiceModel?, client: ClientModel, cesta: CestaModel?) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        servicio = service
        self.cesta = cesta
        
        addGestureRecognizer()
        createContent(cliente: client)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addGestureRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(servicioClicked(_:))))
    }
    
    func createContent(cliente: ClientModel) {
        customizeView()
        
        if servicio != nil {
            addTitleWithString(title: "SERVICIO")
            createServiceContent(cliente: cliente)
        } else {
            addTitleWithString(title: "VENTA")
            createCestaContent(cliente: cliente)
        }
    }
    
    func createServiceContent(cliente: ClientModel) {
        addFieldForServiceField(serviceField: "Nombre y Apellidos", serviceValue: cliente.nombre + " " + cliente.apellidos, addDivisory: true)
        addFieldForServiceField(serviceField: "Fecha", serviceValue: CommonFunctions.getDateAndTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(servicio.fecha))), addDivisory: true)
        addFieldForServiceField(serviceField: "Profesional", serviceValue: Constants.databaseManager.empleadosManager.getEmpleadoFromDatabase(empleadoId: servicio.empleadoId)!.nombre, addDivisory: true)
        addFieldForServiceField(serviceField: "Servicio", serviceValue: CommonFunctions.getServiciosStringFromServiciosArray(servicios: servicio.servicios), addDivisory: true)
        addFieldForServiceField(serviceField: "Precio", serviceValue: String(format: "%.2f", servicio.precio) + " €", addDivisory: true)
        
        addObservacionView()
        
        setContentContraints()
    }
    
    func createCestaContent(cliente: ClientModel) {
        addFieldForServiceField(serviceField: "Nombre y Apellidos", serviceValue: cliente.nombre + " " + cliente.apellidos, addDivisory: true)
        addFieldForServiceField(serviceField: "Fecha", serviceValue: CommonFunctions.getDateAndTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(cesta.fecha))), addDivisory: true)
        
        let ventas: [VentaModel] = Constants.databaseManager.ventaManager.getVentas(cestaId: cesta.cestaId)
        addFieldForServiceField(serviceField: "Precio venta", serviceValue: String(format: "%.2f", calcularVentaTotal(ventas:ventas)) + " €", addDivisory: false)
        
        setContentContraints()
    }
    
    func customizeView() {
        layer.cornerRadius = 15
        layer.borderColor = AppStyle.getSecondaryColor().cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }
    
    func addTitleWithString(title: String) {
        titleLabel.frame = .zero
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        titleLabel.textColor = AppStyle.getPrimaryTextColor()
        addSubview(titleLabel)
    }
    
    func addFieldForServiceField(serviceField: String, serviceValue: String, addDivisory: Bool) {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let serviceFieldLabel: UILabel = UILabel()
        serviceFieldLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceFieldLabel.text = serviceField
        serviceFieldLabel.textColor = AppStyle.getPrimaryTextColor()
        serviceFieldLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.addSubview(serviceFieldLabel)
        
        let serviceValueLabel: UILabel = UILabel()
        serviceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceValueLabel.text = serviceValue
        serviceValueLabel.textColor = AppStyle.getSecondaryTextColor()
        serviceValueLabel.textAlignment = .right
        serviceValueLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.addSubview(serviceValueLabel)
        
        var divisory: UIView!
        if addDivisory {
            divisory = UIView()
            divisory.translatesAutoresizingMaskIntoConstraints = false
            divisory.backgroundColor = AppStyle.getSecondaryColor()
            view.addSubview(divisory)
        }
        
        fieldArray.append(view)
        
        view.heightAnchor.constraint(equalToConstant: fieldHeigth).isActive = true
        
        serviceFieldLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        serviceFieldLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        serviceFieldLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultMargin).isActive = true
        serviceFieldLabel.widthAnchor.constraint(equalToConstant: fieldWidth).isActive = true
        
        serviceValueLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        serviceValueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        serviceValueLabel.leadingAnchor.constraint(equalTo: serviceFieldLabel.trailingAnchor, constant: defaultMargin).isActive = true
        serviceValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -defaultMargin).isActive = true
        
        if divisory != nil {
            divisory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: defaultMargin).isActive = true
            divisory.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            divisory.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            divisory.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
    }
    
    func addObservacionView() {
        let observacionText: String = servicio.observaciones.count > 0 ? servicio.observaciones : "Añade una observación"
        observacionesLabel = UILabel()
        observacionesLabel.translatesAutoresizingMaskIntoConstraints = false
        observacionesLabel.text = observacionText
        observacionesLabel.numberOfLines = 100
        observacionesLabel.textColor = AppStyle.getPrimaryTextColor()
        observacionesLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        addSubview(observacionesLabel)
    }
    
    func setContentContraints() {
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        var previousView: UIView!
        for view: UIView in fieldArray {
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: previousView != nil ? previousView.bottomAnchor: titleLabel.bottomAnchor, constant: previousView != nil ? 0 : defaultMargin).isActive = true
            previousView = view
        }
        
        if observacionesLabel != nil {
            observacionesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: defaultMargin).isActive = true
            observacionesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -defaultMargin).isActive = true
            observacionesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
            observacionesLabel.topAnchor.constraint(equalTo: fieldArray.last!.bottomAnchor, constant: observacionesTopMargin).isActive = true
        } else {
            previousView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
    
    func calcularVentaTotal(ventas: [VentaModel]) -> Double {
        var precioTotal: Double = 0.0
        for venta: VentaModel in ventas {
            let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
            precioTotal = precioTotal + (producto.precio * Double(venta.cantidad))
        }
        
        return precioTotal
    }
}

extension ServicioView {
    @objc func servicioClicked(_ sender: UITapGestureRecognizer? = nil) {
        if delegate != nil {
            if servicio != nil {
                delegate.servicioClicked(service: servicio)
            } else {
                delegate.cestaClicked(cesta: cesta)
            }
        }
    }
}
