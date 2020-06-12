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
    
    
    static func getPrimaryTextColor() -> String {
        var primaryTextColor: String = "#000000"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryTextColorKey)) {
            primaryTextColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginPrimaryTextColorKey) as! String
        }
        
        return primaryTextColor
    }
    
    static func getSecondaryTextColor() -> String {
        var secondaryTextColor: String = "#D1D1D6"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginSecondaryTextColorKey)) {
            secondaryTextColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginSecondaryTextColorKey) as! String
        }
        
        return secondaryTextColor
    }
    
    static func getPrimaryColor() -> String {
        var primaryColor: String = "#000000"
        if (UserPreferences.checkValueInUserDefaults(key: Constants.preferencesLoginPrimaryColorKey)) {
            primaryColor = UserPreferences.getValueFromUserDefaults(key: Constants.preferencesLoginPrimaryColorKey) as! String
        }
        
        return primaryColor
    }
}
