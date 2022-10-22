//
//  VentaManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 23/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData


class VentaManager: NSObject {
    let TABLE_ENTITY_NAME: String = "Venta"
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
    }
    
    func getAllVentas() -> [VentaModel] {
        var ventas: [VentaModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    ventas.append(parseVentaCoreObjectToVentaModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return ventas
    }
    
    func addVenta(venta: VentaModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "ventaId = %f", argumentArray: [venta.ventaId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result == nil {
                let entity = NSEntityDescription.entity(forEntityName: TABLE_ENTITY_NAME, in: self.backgroundContext)
                let coreVenta = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                setCoreDataObjectDataFromVenta(coreDataObject: coreVenta, venta: venta)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func updateVenta(venta: VentaModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "ventaId = %f", argumentArray: [venta.ventaId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result != nil {
                setCoreDataObjectDataFromVenta(coreDataObject: result!, venta: venta)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func getVenta(ventaId: Int64) -> VentaModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "ventaId = %f", argumentArray: [ventaId])
        var result: VentaModel?
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                if results.count > 0 {
                    result = parseVentaCoreObjectToVentaModel(coreObject: results.first!)
                }
            } catch {
                print("Error checking the product in database")
            }
        }
        
        return result
    }
    
    func getVentas(cestaId: Int64) -> [VentaModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "cestaId = %f", argumentArray: [cestaId])
        var ventas: [VentaModel] = []
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for result in results {
                    ventas.append(parseVentaCoreObjectToVentaModel(coreObject: result))
                }
            } catch {
                print("Error checking the product in database")
            }
        }
        
        return ventas
    }
    
    func deleteAllVentas() {
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
    
    func deleteVenta(venta: VentaModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "ventaId = %f", argumentArray: [venta.ventaId])
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
    
    func syncronizeVentasAsync(ventas: [VentaModel]) {
        backgroundContext.perform {
             for venta: VentaModel in ventas {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.TABLE_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "ventaId = %f", argumentArray: [venta.ventaId])
                let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
                 
                if result != nil {
                    self.setCoreDataObjectDataFromVenta(coreDataObject: result!, venta: venta)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: self.TABLE_ENTITY_NAME, in: self.backgroundContext)
                    let coreVenta = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    self.setCoreDataObjectDataFromVenta(coreDataObject: coreVenta, venta: venta)
                }
             }
             
             try! self.backgroundContext.save()
         }
    }
    
    private func setCoreDataObjectDataFromVenta(coreDataObject: NSManagedObject, venta: VentaModel) {
        coreDataObject.setValue(venta.cestaId, forKey: "cestaId")
        coreDataObject.setValue(venta.ventaId, forKey: "ventaId")
        coreDataObject.setValue(venta.productoId, forKey: "productoId")
        coreDataObject.setValue(venta.cantidad, forKey: "cantidad")
        coreDataObject.setValue(venta.comercioId, forKey: "comercioId")
    }
    
    private func parseVentaCoreObjectToVentaModel(coreObject: NSManagedObject) -> VentaModel {
        let venta: VentaModel = VentaModel()
        venta.cestaId = coreObject.value(forKey: "cestaId") as! Int64
        venta.ventaId = coreObject.value(forKey: "ventaId") as! Int64
        venta.cantidad = coreObject.value(forKey: "cantidad") as! Int
        venta.productoId = coreObject.value(forKey: "productoId") as! Int64
        venta.comercioId = coreObject.value(forKey: "comercioId") as! Int64
        
        return venta
    }
}
