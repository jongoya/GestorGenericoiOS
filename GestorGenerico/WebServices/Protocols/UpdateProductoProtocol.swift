//
//  UpdateProductoProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol UpdateProductoProtocol {
    func successUpdatingProduct(producto: ProductoModel)
    func errorUpdatingProduct()
    func logoutResponse()
}
