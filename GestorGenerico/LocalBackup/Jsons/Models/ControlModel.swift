//
//  ControlModel.swift
//  GestorGenerico
//
//  Created by jon mikel on 01/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation


class ControlModel: NSObject {
    var identificador1: Int64 = 0
    var identificador2: String = ""
    var antiguaId: Int64 = 0
    var nuevaId: Int64 = 0
    
    init(identificador1: Int64, identificador2: String, antiguaId: Int64) {
        self.identificador1 = identificador1
        self.identificador2 = identificador2
        self.antiguaId = antiguaId
    }
}
