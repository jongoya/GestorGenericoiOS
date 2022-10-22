//
//  EstiloAppModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 16/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation

class EstiloAppModel: Codable {
    var estiloId: Int64 = 0
    var comercioId: Int64 = 0
    var primaryTextColor: String = ""
    var secondaryTextColor: String = ""
    var primaryColor: String = ""
    var secondaryColor: String = ""
    var backgroundColor: String = ""
    var navigationColor: String = ""
    var appSmallIcon: String = ""
    var appName: String = ""
    
    private enum CodingKeys: String, CodingKey {
        case estiloId = "estiloId"
        case comercioId = "comercioId"
        case primaryTextColor = "primaryTextColor"
        case secondaryTextColor = "secondaryTextColor"
        case primaryColor = "primaryColor"
        case secondaryColor = "secondaryColor"
        case backgroundColor = "backgroundColor"
        case navigationColor = "navigationColor"
        case appSmallIcon = "appSmallIcon"
        case appName = "appName"
    }
}
