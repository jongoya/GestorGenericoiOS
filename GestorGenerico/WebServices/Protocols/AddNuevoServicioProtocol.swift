//
//  AddServicioProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 13/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol AddNuevoServicioProtocol {
    func successSavingService(servicio: ServiceModel)
    func errorSavingServicio()
}
