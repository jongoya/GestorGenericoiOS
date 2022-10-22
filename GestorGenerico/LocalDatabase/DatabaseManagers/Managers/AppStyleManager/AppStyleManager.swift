//
//  AppStyleManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 16/06/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData


class AppStyleManager: NSObject {
    let ESTILO_ENTITY_NAME: String = "EstiloApp"
    var databaseHelper: DatabaseHelper!
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
        databaseHelper = DatabaseHelper()
    }
    
    func getEstiloFromDatabase() -> EstiloAppModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ESTILO_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        var estilo: EstiloAppModel!
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                let coreEstilo: NSManagedObject = results.first!
                estilo = databaseHelper.parseCoreEstiloObjectToEstiloObject(coreEstiloObject: coreEstilo)
            } catch {
            }
        }

        return estilo
    }
    
    func addEstiloToDatabase(estilo: EstiloAppModel) {
        let entity = NSEntityDescription.entity(forEntityName: ESTILO_ENTITY_NAME, in: backgroundContext)
        let coreEstilo = NSManagedObject(entity: entity!, insertInto: backgroundContext)
        databaseHelper.setCoreEstiloObjectFromEstiloModel(coreDataObject: coreEstilo, estiloApp: estilo)
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
            } catch {
            }
        }
    }
    
    func deleteStyle() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ESTILO_ENTITY_NAME)
                var results: [NSManagedObject] = []
        backgroundContext.performAndWait {
            do {
                results = try backgroundContext.fetch(fetchRequest)
                for object in results {
                    backgroundContext.delete(object)
                }
                
                try backgroundContext.save()
            } catch {
            }
        }
    }
    
    func updateEstiloPrivadoInDatabase(estilo: EstiloAppModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: ESTILO_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        backgroundContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                let coreEstilo: NSManagedObject = results.first!
                databaseHelper.setCoreEstiloObjectFromEstiloModel(coreDataObject: coreEstilo, estiloApp: estilo)
                try backgroundContext.save()
            } catch {
            }
        }
    }
}
