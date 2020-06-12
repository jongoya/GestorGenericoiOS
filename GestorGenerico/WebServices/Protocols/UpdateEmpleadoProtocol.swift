//
//  UpdateEmpleadoProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 12/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


protocol UpdateEmpleadoProtocol {
    func successUpdatingEmpleado(empleado: EmpleadoModel)
    func errorUpdatingEmpleado()
}
