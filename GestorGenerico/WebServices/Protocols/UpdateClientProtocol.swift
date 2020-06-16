//
//  UpdateClientProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 13/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol UpdateClientProtocol {
    func successUpdatingClient(cliente: ClientModel)
    func errorUpdatingClient()
    func logoutResponse()
}
