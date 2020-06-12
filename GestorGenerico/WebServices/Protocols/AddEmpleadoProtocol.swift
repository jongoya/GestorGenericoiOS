//
//  AddEmpleadoProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 12/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol AddEmpleadoProtocol {
    func successSavingEmpleado(empleado: EmpleadoModel)
    func errorSavingEmpleado()
}
