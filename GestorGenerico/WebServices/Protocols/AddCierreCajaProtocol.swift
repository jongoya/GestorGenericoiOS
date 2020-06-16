//
//  AddCierreCajaProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 15/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol AddCierreCajaProtocol {
    func successAddingCierreCaja(caja: CierreCajaModel)
    func errorAddingCierreCaja()
    func logoutResponse()
}
