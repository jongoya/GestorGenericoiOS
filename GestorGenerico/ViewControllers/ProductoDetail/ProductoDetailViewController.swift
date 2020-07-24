//
//  ProductoDetailViewController.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class ProductoDetailViewController: UIViewController {
    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var tituloField: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var nombreField: UILabel!
    @IBOutlet weak var nombreArrow: UIImageView!
    @IBOutlet weak var nombreDivisory: UIView!
    @IBOutlet weak var numeroLabel: UILabel!
    @IBOutlet weak var numeroField: UILabel!
    @IBOutlet weak var numeroArrow: UIImageView!
    @IBOutlet weak var numeroDivisory: UIView!
    @IBOutlet weak var codigoBarrasLabel: UILabel!
    @IBOutlet weak var codigoBarrasField: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var precioField: UILabel!
    @IBOutlet weak var precioArrow: UIImageView!
    @IBOutlet weak var precioDivisory: UIView!
    
    var producto: ProductoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detalle"
        addSaveProductoButton()
        customizeLabels()
        customizeFields()
        customizeImages()
        customizeViews()
        setProductDetails()
    }
    
    func addSaveProductoButton() {
        var rightButtons: [UIBarButtonItem] = []
        rightButtons.append(UIBarButtonItem(image: UIImage(systemName: "checkmark"), style: .done, target: self, action: #selector(didClickSaveProductoButton)))
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    func customizeLabels() {
        tituloField.textColor = AppStyle.getPrimaryTextColor()
        nombreLabel.textColor = AppStyle.getPrimaryTextColor()
        numeroLabel.textColor = AppStyle.getPrimaryTextColor()
        codigoBarrasLabel.textColor = AppStyle.getPrimaryTextColor()
        precioLabel.textColor = AppStyle.getPrimaryTextColor()
    }
    
    func customizeFields() {
        nombreField.textColor = AppStyle.getSecondaryTextColor()
        numeroField.textColor = AppStyle.getSecondaryTextColor()
        codigoBarrasField.textColor = AppStyle.getSecondaryTextColor()
        precioField.textColor = AppStyle.getSecondaryTextColor()
    }
    
    func customizeImages() {
        nombreArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        nombreArrow.tintColor = AppStyle.getSecondaryColor()
        numeroArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        numeroArrow.tintColor = AppStyle.getSecondaryColor()
        precioArrow.image = UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
        precioArrow.tintColor = AppStyle.getSecondaryColor()
        nombreDivisory.backgroundColor = AppStyle.getSecondaryColor()
        numeroDivisory.backgroundColor = AppStyle.getSecondaryColor()
        precioDivisory.backgroundColor = AppStyle.getSecondaryColor()
    }
    
    func customizeViews() {
        rootView.backgroundColor = AppStyle.getBackgroundColor()
        scrollView.backgroundColor = AppStyle.getBackgroundColor()
        scrollContentView.backgroundColor = AppStyle.getBackgroundColor()
    }
    
    func setProductDetails() {
        nombreField.text = producto.nombre
        if producto.numProductos > 0 {
            numeroField.text = String(producto.numProductos)
        }
        
        if producto.precio > 0 {
            precioField.text = String(format: "%.2f", producto.precio) + " €"
        }
        codigoBarrasField.text = producto.codigoBarras
        setProductImage()
    }
    
    func setProductImage() {
        if producto.imagen.count > 0 {
            let dataDecoded : Data = Data(base64Encoded: producto.imagen, options: .ignoreUnknownCharacters)!
            productImage.image = UIImage(data: dataDecoded)
            productImage.layer.cornerRadius = 75
        } else {
            productImage.image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
            productImage.tintColor = AppStyle.getPrimaryTextColor()
        }
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
    
    private func checkFields() {
        if nombreField.text?.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un nombre de producto", viewController: self)
            return
        }
        
        if numeroField.text?.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir una cantidad en stock", viewController: self)
            return
        }
        
        if precioField.text?.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Debe incluir un precio al producto", viewController: self)
            return
        }
        
        if producto.imagen.count == 0 {
            CommonFunctions.showGenericAlertMessage(mensaje: "Sácale una foto al producto", viewController: self)
            return
        }
        
        if producto.productoId > 0 {
            CommonFunctions.showLoadingStateView(descriptionText: "Actualizando producto")
            WebServices.updateProducto(producto: producto, delegate: self)
        } else {
            CommonFunctions.showLoadingStateView(descriptionText: "Guardando producto")
            WebServices.addProducto(producto: producto, delegate: self)
        }
    }
}

extension ProductoDetailViewController {
    @IBAction func didClickNombre(_ sender: Any) {
        showInputFieldView(inputReference: 1, keyBoardType: .default, text: nombreField.text!, controllerTitle: "Nombre")
    }
    
    @IBAction func didClickCantidadStock(_ sender: Any) {
        showInputFieldView(inputReference: 2, keyBoardType: .numberPad, text: numeroField.text!, controllerTitle: "Cantidad")
    }
    
    @IBAction func didClickImage(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func didClickSaveProductoButton(sender: UIBarButtonItem) {
        checkFields()
    }
    
    @IBAction func didClickPrecio(_ sender: Any) {
        showInputFieldView(inputReference: 3, keyBoardType: .decimalPad, text: precioField.text!, controllerTitle: "Precio")
    }
}

extension ProductoDetailViewController: AddClientInputFieldProtocol {
    func textSaved(text: String, inputReference: Int) {
        switch inputReference {
        case 1:
            producto.nombre = text
            nombreField.text = text
        case 2:
            producto.numProductos = Int(text) ?? 0
            numeroField.text = text
        case 3:
            let value = text.replacingOccurrences(of: ",", with: ".")
            precioField.text = value + " €"
            producto.precio = (value as NSString).doubleValue
        default:
            break
        }
    }
}

extension ProductoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        productImage.layer.cornerRadius = 75
        let image = info[.originalImage] as! UIImage
        let resizedImage = CommonFunctions.resizeImage(image: image, targetSize: CGSize(width: 150, height: 150))
        productImage.image = resizedImage
        let imageData: Data = resizedImage.pngData()!
        let imageString: String = imageData.base64EncodedString()
        producto.imagen = imageString
    }
}

extension ProductoDetailViewController: AddProductoProtocol {
    func successAddingProduct(producto: ProductoModel) {
        CommonFunctions.hideLoadingStateView()
        Constants.databaseManager.productosManager.addProducto(producto: producto)
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorAddingProduct() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error guardando el producto", viewController: self)
    }
    
    func logoutResponse() {
        CommonFunctions.showLogoutAlert(viewController: self)
    }
}

extension ProductoDetailViewController: UpdateProductoProtocol {
    func successUpdatingProduct(producto: ProductoModel) {
        CommonFunctions.hideLoadingStateView()
        Constants.databaseManager.productosManager.updateProducto(producto: producto)
        self.navigationController!.popViewController(animated: true)
    }
    
    func errorUpdatingProduct() {
        CommonFunctions.hideLoadingStateView()
        CommonFunctions.showGenericAlertMessage(mensaje: "Error actualizando el producto", viewController: self)
    }
}
