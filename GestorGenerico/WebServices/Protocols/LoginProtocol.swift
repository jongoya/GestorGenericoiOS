//
//  LoginProtocol.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

protocol LoginProtocol {
    func successGettingLoginStyle(estiloLogin: EstiloLoginModel)
    func errorGettingLoginStyle()
    func succesLogingIn(loginCompleto: LoginMasDispositivosModel)
    func errorLoginIn()
    func tooMuchDevicesLogingIn(loginMasDispositivosModel: LoginMasDispositivosModel)
}
