//
//  CajaModel.swift
//  GestorHeme
//
//  Created by jon mikel on 21/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class CierreCajaModel: Codable {
    var cajaId: Int64 = 0
    var fecha: Int64 = 0
    var numeroServicios: Int = 0
    var totalCaja: Double = 0.0
    var totalProductos: Double = 0.0
    var efectivo: Double = 0.0
    var tarjeta: Double = 0.0
    var comercioId: Int64 = 0
    
    private enum CodingKeys: String, CodingKey {
        case cajaId = "cajaId"
        case fecha = "fecha"
        case numeroServicios = "numeroServicios"
        case totalCaja = "totalCaja"
        case totalProductos = "totalProductos"
        case efectivo = "efectivo"
        case tarjeta = "tarjeta"
        case comercioId = "comercioId"
    }
}

extension CierreCajaModel {
    func createJson() -> [String: Any] {
        return ["cajaId" : cajaId, "fecha" : fecha, "numeroServicios" : numeroServicios, "totalCaja" : totalCaja, "totalProductos" : totalProductos, "efectivo" : efectivo, "tarjeta" : tarjeta, "comercioId" : comercioId]
    }
}
