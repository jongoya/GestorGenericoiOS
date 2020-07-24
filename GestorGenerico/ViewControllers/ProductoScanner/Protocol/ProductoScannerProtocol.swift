//
//  ProductoScannerProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol ProductoScannerProtocol {
    func codigoBarrasDetected(codigoBarras: String)
    func errorDetectingCodigoBarras()
}
