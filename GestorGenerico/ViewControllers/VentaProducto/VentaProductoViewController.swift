//
//  VentaProductoViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 22/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class VentaProductoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var nombreDivisory: UIView!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var fechaField: UILabel!
    @IBOutlet weak var fechaArrow: UIImageView!
    @IBOutlet weak var fechaDivisory: UIView!
    @IBOutlet weak var efectivoLabel: UILabel!
    @IBOutlet weak var efectivoSwitch: UISwitch!
    @IBOutlet weak var titutoProductos: UILabel!
    @IBOutlet weak var scrollContent: UIView!
    
    var cesta: CestaModel!
    var ventas: [VentaModel] = []
    var productosViews: [ProductoView] = []
    var ventaPosition: Int = 0
    var delegate: ClientUpdateCestaProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Venta"
        efectivoSwitch.addTarget(self, action: #selector(switchClicked), for: UIControl.Event.valueChanged)
        customizeLabels()
        customizeArrows()
        customizeViews()
        customizeSwitch()
        addAddProductoButton()
        
        if cesta != nil {
            setCestaDetail()
        } else {
            cesta = CestaModel()
        }
        
        addProductosViews()
    }
    
    func customizeLabels() {
        titulo.textColor = AppStyle.getPrimaryTextColor()
        nombreLabel.textColor = AppStyle.getPrimaryTextColor()
        fechaLabel.textColor = AppStyle.getPrimaryTextColor()
        efectivoLabel.textColor = AppStyle.getPrimaryTextColor()
        titutoProductos.textColor = AppStyle.getPrimaryTextColor()
        nombreField.textColor = AppStyle.getSecondaryTextColor()
        fechaField.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeViews() {
        rootView.backgroundColor = AppStyle.getBackgroundColor()
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
        nombreDivisory.backgroundColor = AppStyle.getSecondaryColor()
        fechaDivisory.backgroundColor = AppStyle.getSecondaryColor()
    }
    
    func customizeArrows() {
        nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        fechaArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        nombreArrow.tintColor = AppStyle.getSecondaryTextColor()
        fechaArrow.tintColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeSwitch() {
        efectivoSwitch.onTintColor = AppStyle.getPrimaryColor()
    }
    
    func addAddProductoButton() {
        var rightButtons: [UIBarButtonItem] = []
        rightButtons.append(UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveButton)))
        rightButtons.append(UIBarButtonItem(image: UIImage(systemName: "barcode"), style: .done, target: self, action: #selector(didClickBarcodeButton)))
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    func addProductosViews() {
        removeProductosViews()
        var previousView: UIView = titutoProductos
        
        for i in 0...ventas.count - 1 {
            let venta: VentaModel = ventas[i]
            let view: ProductoView = ProductoView(venta: venta, position: i, isLastProduct: i == ventas.count - 1, delegate: self, enableClick: cesta.cestaId == 0)
            scrollContent.addSubview(view)
            view.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: previousView == titutoProductos ? 15 : 0).isActive = true
            view.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor).isActive = true
            productosViews.append(view)
            previousView = view
        }
    }
    
    func setCestaDetail() {
        let cliente: ClientModel = Constants.databaseManager.clientsManager.getClientFromDatabase(clientId: cesta.clientId)!
        nombreField.text = cliente.nombre + " " + cliente.apellidos
        fechaField.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: Date(timeIntervalSince1970: TimeInterval(cesta.fecha)))
        efectivoSwitch.setOn(cesta.isEfectivo, animated: false)
    }
    
    private func openProductScanner() {
        let scannerViewController: ScannerViewController = ScannerViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true, completion: nil)
    }
    
    func removeProductosViews() {
        for producto: ProductoView in productosViews {
            producto.removeFromSuperview()
        }
        
        productosViews = []
    }
    
    func showInputFieldView(inputReference: Int, keyBoardType: UIKeyboardType, text: String, controllerTitle: String) {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: FieldViewController = showItemStoryboard.instantiateViewController(withIdentifier: "FieldViewController") as! FieldViewController
        controller.inputReference = inputReference
        controller.delegate = self
        controller.keyboardType = keyBoardType
        controller.inputText = text
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openDatePickerView() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: DatePickerSelectorViewController = showItemStoryboard.instantiateViewController(withIdentifier: "DatePickerSelectorViewController") as! DatePickerSelectorViewController
        controller.delegate = self
        controller.datePickerMode = .dateAndTime
        controller.initialDate = 0
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func openClientSelector() {
        let showItemStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ClientListSelectorViewController = showItemStoryboard.instantiateViewController(withIdentifier: "clientSelector") as! ClientListSelectorViewController
        controller.delegate = self
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func isProductInCesta(producto: ProductoModel) -> Bool {
        for venta: VentaModel in ventas {
            if venta.productoId == producto.productoId {
                return true
            }
        }
        
        return false
    }
    
    func checkFields() {
        if nombreField.text?.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe seleccionar un cliente", viewController: self)
            return
        }
        
        if fechaField.text?.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe indicar una fecha de compra", viewController: self)
            return
        }
        
        if cesta.cestaId == 0 {
            CommonFunctions.showLoadingStateView(descriptionText: "Guardando cesta")
            WebServices.saveCesta(cesta: cesta, ventas: ventas, delegate: self)
        } else {
            CommonFunctions.showLoadingStateView(descriptionText: "Actualizando cesta")
            WebServices.updateCesta(cesta: cesta, ventas: ventas, delegate: self)
        }
    }
}

extension VentaProductoViewController {
    @IBAction func didClickFecha(_ sender: Any) {
        openDatePickerView()
    }
    
    @objc func switchClicked(mySwitch: UISwitch) {
        cesta.isEfectivo = mySwitch.isOn
    }
    
    @IBAction func didClickNombre(_ sender: Any) {
        openClientSelector()
    }
    
    @objc func didClickBarcodeButton() {
        openProductScanner()
    }
    
    @objc func didClickSaveButton() {
        checkFields()
    }
}

extension VentaProductoViewController: ProductoScannerProtocol {
    func codigoBarrasDetected(codigoBarras: String) {
        let producto: ProductoModel? = Constants.databaseManager.productosManager.getProductWithBarcode(barcode: codigoBarras)
        if producto == nil {
            CommonFunctions.showGenericAlertMessage(mensaje: "El producto no se encuentra en stock", viewController: self)
            return
        }
        
        if !isProductInCesta(producto: producto!) {
            ventas.append(VentaModel(productoId: producto!.productoId))
            addProductosViews()
        } else {
            CommonFunctions.showGenericAlertMessage(mensaje: "El producto ya se encuentra en la cesta", viewController: self)
        }
    }
    
    func errorDetectingCodigoBarras() {
        CommonFunctions.showGenericAlertMessage(mensaje: "Error recogiendo el codigo de barras", viewController: self)
    }
}

extension VentaProductoViewController: ProductoViewProtocol {
    func ventaClicked(ventaPosition: Int) {
        self.ventaPosition = ventaPosition
        showInputFieldView(inputReference: 1, keyBoardType: .numberPad, text: String(ventas[ventaPosition].cantidad), controllerTitle: "Cantidad")
    }
}

extension VentaProductoViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: ventas[ventaPosition].productoId)!
            let cantidad: Int = Int(text) ?? 1
            if producto.numProductos < cantidad {
                ventas[ventaPosition].cantidad = producto.numProductos
                CommonFunctions.showGenericAlertMessage(mensaje: "Ha superado la cantidad en stock de este producto, se ha seleccionado la cantidad disponible", viewController: self)
            } else {
                ventas[ventaPosition].cantidad = cantidad
            }
            
            addProductosViews()
        default:
            break
        }
    }
}

extension VentaProductoViewController: DatePickerSelectorProtocol {
    func dateSelected(date: Date) {
        cesta.fecha = Int64(date.timeIntervalSince1970)
        fechaField.text = CommonFunctions.getDateAndTimeTypeStringFromDate(date: date)
    }
}

extension VentaProductoViewController: ClientListSelectorProtocol {
    func clientSelected(client: ClientModel) {
        nombreField.text = client.nombre + " " + client.apellidos
        cesta.clientId = client.id
    }
}

extension VentaProductoViewController: SaveCestaProtocol {
    func successSavingCesta(model: CestaMasVentas) {
        CommonFunctions.hideLoadingStateView()
        Constants.databaseManager.cestaManager.addCesta(cesta: model.cesta)
        for venta: VentaModel in model.ventas {
            Constants.databaseManager.ventaManager.addVenta(venta: venta)
            let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
            producto.numProductos = producto.numProductos - venta.cantidad
            Constants.databaseManager.productosManager.updateProducto(producto: producto)
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorSavingCesta() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando la cesta, inténtelo de nuevo", viewController: self)
    }
    
    func logoutResponse() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showLogoutAlert(viewController: self)
    }
}

extension VentaProductoViewController: UpdateCestaProtocol {
    func successUpdatingCesta(model: CestaMasVentas) {
        CommonFunctions.hideLoadingStateView()
        Constants.databaseManager.cestaManager.updateCesta(cesta: model.cesta)
        for venta: VentaModel in model.ventas {
            let ventaLocal: VentaModel? = Constants.databaseManager.ventaManager.getVenta(ventaId: venta.ventaId)
            if ventaLocal == nil {
                Constants.databaseManager.ventaManager.addVenta(venta: venta)
                let producto: ProductoModel = Constants.databaseManager.productosManager.getProductWithProductId(productId: venta.productoId)!
                producto.numProductos = producto.numProductos - venta.cantidad
                Constants.databaseManager.productosManager.updateProducto(producto: producto)
            }
        }
        
        if delegate != nil {
            delegate.cestaUpdated()
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorUpdatingCesta() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando la cesta, inténtelo de nuevo", viewController: self)
    }
}
