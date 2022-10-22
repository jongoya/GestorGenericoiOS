//
//  SaveCestaProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 23/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol SaveCestaProtocol {
    func successSavingCesta(model: CestaMasVentas)
    func errorSavingCesta()
    func logoutResponse()
}
