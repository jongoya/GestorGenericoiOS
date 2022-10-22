//
//  UserDefaults.swift
//  GestorHeme
//
//  Created by jon mikel on 04/05/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {

    static func saveValueInUserDefaults(value: Any, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func checkValueInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) != nil
    }
    
    static func getValueFromUserDefaults(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key)!
    }
    
    static func deleteAllValues() {
        UserDefaults.standard.removeObject(forKey: Constants.preferencesTokenKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesPasswordKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesComercioIdKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginBackgroundKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginIconoKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginPrimaryTextColorKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginSecondaryTextColorKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginPrimaryColorKey)
        UserDefaults.standard.removeObject(forKey: Constants.preferencesLoginNombreAppKey)
    }
}
