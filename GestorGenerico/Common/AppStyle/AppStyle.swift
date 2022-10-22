//
//  AppStyle.swift
//  GestorGenerico
//
//  Created by jon mikel on 11/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import Foundation
import UIKit


class AppStyle {
    static let defaultCornerRadius: CGFloat = 10
    static let defaultBorderWidth: CGFloat = 1
    
    
    static func getLoginPrimaryTextColor() -> String {
        var primaryTextColor: String = "#000000"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryTextColorKey)) {
            primaryTextColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginPrimaryTextColorKey) as! String
        }
        
        return primaryTextColor
    }
    
    static func getLoginSecondaryTextColor() -> String {
        var secondaryTextColor: String = "#D1D1D6"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginSecondaryTextColorKey)) {
            secondaryTextColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginSecondaryTextColorKey) as! String
        }
        
        return secondaryTextColor
    }
    
    static func getLoginPrimaryColor() -> String {
        var primaryColor: String = "#000000"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryColorKey)) {
            primaryColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginPrimaryColorKey) as! String
        }
        
        return primaryColor
    }
    
    static func getPrimaryTextColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.primaryTextColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#000000")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.primaryTextColor)
    }
    
    static func getSecondaryTextColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.secondaryTextColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#8E8E93")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.secondaryTextColor)
    }
    
    static func getBackgroundColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.backgroundColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#F2F2F7")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.backgroundColor)
    }
    
    static func getPrimaryColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.primaryColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#000000")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.primaryColor)
    }
    
    static func getSecondaryColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.secondaryColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#8E8E93")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.secondaryColor)
    }
    
    static func getAppName() -> String {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.appName.count == 0 {
           return "Cuenta"
        }
        
        return estiloApp.appName
    }
    
    static func getAppSmallIcon() -> String {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!

        if estiloApp.appSmallIcon.count == 0 {
           return ""
        }
        
        //TODO
        //return estiloApp.appSmallIcon
        return ""
    }
    
    static func getNavigationColor() -> UIColor {
        let estiloApp: EstiloAppModel = Constants.databaseManager.estiloAppManager.getEstiloFromDatabase()!
        
        if estiloApp.navigationColor.count == 0 {
            return CommonFunctions.hexStringToUIColor(hex: "#F2F2F7")
        }

        return CommonFunctions.hexStringToUIColor(hex: estiloApp.navigationColor)
    }
    
}
