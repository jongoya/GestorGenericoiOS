//
//  EstiloLoginModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 09/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class EstiloLoginModel: Codable {
    var estiloId: Int64 = 0
    var androidBundleId: String = ""
    var iosBundleId: String = ""
    var fondoLogin: String?
    var primaryTextColor: String?
    var secondaryTextColor: String?
    var primaryColor: String?
    var nombreApp: String = ""
    var iconoApp: String?
    
    private enum CodingKeys: String, CodingKey {
        case estiloId = "estiloId"
        case androidBundleId = "androidBundleId"
        case iosBundleId = "iosBundleId"
        case fondoLogin = "fondoLogin"
        case primaryTextColor = "primaryTextColor"
        case secondaryTextColor = "secondaryTextColor"
        case primaryColor = "primaryColor"
        case nombreApp = "nombreApp"
        case iconoApp = "iconoApp"
    }
}
