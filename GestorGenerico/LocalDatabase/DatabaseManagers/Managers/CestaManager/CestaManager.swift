//
//  CestaManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 23/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class CestaManager: NSObject {
    let TABLE_ENTITY_NAME: String = "Cesta"
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
    }
    
    func getAllCestas() -> [CestaModel] {
        var cestas: [CestaModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    cestas.append(parseCestaCoreObjectToCestaModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return cestas
    }
    
    func addCesta(cesta: CestaModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cesta.cestaId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result == nil {
                let entity = NSEntityDescription.entity(forEntityName: TABLE_ENTITY_NAME, in: self.backgroundContext)
                let coreCesta = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                setCoreDataObjectDataFromCesta(coreDataObject: coreCesta, cesta: cesta)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func updateCesta(cesta: CestaModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cesta.cestaId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result != nil {
                setCoreDataObjectDataFromCesta(coreDataObject: result!, cesta: cesta)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func getCesta(cestaId: Int64) -> CestaModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cestaId])
        var result: CestaModel?
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                if results.count > 0 {
                    result = parseCestaCoreObjectToCestaModel(coreObject: results.first!)
                }
            } catch {
                print("Error checking the product in database")
            }
        }
        
        return result
    }
    
    func getCestasForClientId(clientId: Int64) -> [CestaModel] {
        var cestas: [CestaModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "clientId = %f", argumentArray: [clientId])
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    cestas.append(parseCestaCoreObjectToCestaModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return cestas
    }
    
    func getCestasForDay(date: Date) -> [CestaModel] {
        let beginningOfDay: Int64 = Int64(AgendaFunctions.getBeginningOfDayFromDate(date: date).timeIntervalSince1970)
        let endOfDay: Int64 = Int64(AgendaFunctions.getEndOfDayFromDate(date: date).timeIntervalSince1970)
        let cestas: [CestaModel] = getAllCestasForDay(beginingOfDay: beginningOfDay, endOfDay: endOfDay)
        
        return cestas
    }
    
    func getAllCestasForDay(beginingOfDay: Int64, endOfDay: Int64) -> [CestaModel] {
        var cestas: [CestaModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "fecha > %f AND fecha < %f", argumentArray: [beginingOfDay, endOfDay])
        fetchRequest.returnsObjectsAsFaults = false
        
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    cestas.append(parseCestaCoreObjectToCestaModel(coreObject: data))
                }
            } catch {
            }
        }

        return cestas
    }
    
    func deleteAllCestas() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
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
    
    func deleteCesta(cesta: CestaModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cesta.cestaId])
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
    
    func syncronizeCestasAsync(cestas: [CestaModel]) {
        backgroundContext.perform {
             for cesta: CestaModel in cestas {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.TABLE_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cesta.cestaId])
                let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
                 
                if result != nil {
                    self.setCoreDataObjectDataFromCesta(coreDataObject: result!, cesta: cesta)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: self.TABLE_ENTITY_NAME, in: self.backgroundContext)
                    let coreCesta = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    self.setCoreDataObjectDataFromCesta(coreDataObject: coreCesta, cesta: cesta)
                }
             }
             
             try! self.backgroundContext.save()
         }
    }
    
    private func setCoreDataObjectDataFromCesta(coreDataObject: NSManagedObject, cesta: CestaModel) {
        coreDataObject.setValue(cesta.clientId, forKey: "clientId")
        coreDataObject.setValue(cesta.cestaId, forKey: "cestaId")
        coreDataObject.setValue(cesta.fecha, forKey: "fecha")
        coreDataObject.setValue(cesta.isEfectivo, forKey: "isEfectivo")
        coreDataObject.setValue(cesta.comercioId, forKey: "comercioId")
    }
    
    private func parseCestaCoreObjectToCestaModel(coreObject: NSManagedObject) -> CestaModel {
        let cesta: CestaModel = CestaModel()
        cesta.cestaId = coreObject.value(forKey: "cestaId") as! Int64
        cesta.clientId = coreObject.value(forKey: "clientId") as! Int64
        cesta.fecha = coreObject.value(forKey: "fecha") as! Int64
        cesta.isEfectivo = coreObject.value(forKey: "isEfectivo") as! Bool
        cesta.comercioId = coreObject.value(forKey: "comercioId") as! Int64
        
        return cesta
    }
}
