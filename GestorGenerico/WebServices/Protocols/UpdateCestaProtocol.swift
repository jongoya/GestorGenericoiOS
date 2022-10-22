//
//  UpdateCestaProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 24/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol UpdateCestaProtocol {
    func successUpdatingCesta(model: CestaMasVentas)
    func errorUpdatingCesta()
    func logoutResponse()
}
