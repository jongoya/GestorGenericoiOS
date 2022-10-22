//
//  ProductoModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class ProductoModel: Codable {
    var productoId: Int64 = 0
    var nombre: String = ""
    var codigoBarras: String = ""
    var imagen: String = ""
    var numProductos: Int = 0
    var comercioId: Int64 = 0
    var precio: Double = 0.0
    
    init(codigoBarras: String) {
        self.codigoBarras = codigoBarras
    }
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case productoId = "productoId"
        case nombre = "nombre"
        case codigoBarras = "codigoBarras"
        case imagen = "imagen"
        case numProductos = "numProductos"
        case comercioId = "comercioId"
        case precio = "precio"
    }
}

extension ProductoModel {
    func createJson() -> [String: Any] {
        return ["productoId" : productoId, "nombre" : nombre, "codigoBarras" : codigoBarras, "imagen" : imagen, "numProductos" : numProductos, "precio" : precio, "comercioId" : comercioId]
    }
}
