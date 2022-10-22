//
//  AddProductoProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol AddProductoProtocol {
    func successAddingProduct(producto: ProductoModel)
    func errorAddingProduct()
    func logoutResponse()
}
