//
//  ProductoManager.swift
//  GestorGenerico
//
//  Created by jon mikel on 21/07/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class ProductoManager: NSObject {
    let TABLE_ENTITY_NAME: String = "Producto"
    
    var backgroundContext: NSManagedObjectContext!//para escritura
    var mainContext: NSManagedObjectContext!//para lectura
    
    override init() {
        super.init()
        let app = UIApplication.shared.delegate as! AppDelegate
        backgroundContext = app.persistentContainer.newBackgroundContext()
        mainContext = app.persistentContainer.viewContext
    }
    
    func getAllProductos() -> [ProductoModel] {
        var productos: [ProductoModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    productos.append(parseProductoCoreObjectToProductoModel(coreObject: data))
                }
            } catch {
            }
        }
    
        return productos
    }
    
    func addProducto(producto: ProductoModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "productoId = %f", argumentArray: [producto.productoId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result == nil {
                let entity = NSEntityDescription.entity(forEntityName: TABLE_ENTITY_NAME, in: self.backgroundContext)
                let coreProducto = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                setCoreDataObjectDataFromProducto(coreDataObject: coreProducto, producto: producto)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func updateProducto(producto: ProductoModel) {
        backgroundContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
            fetchRequest.predicate = NSPredicate(format: "productoId = %f", argumentArray: [producto.productoId])
            let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
            
            if result != nil {
                setCoreDataObjectDataFromProducto(coreDataObject: result!, producto: producto)
            }
            
            try! self.backgroundContext.save()
        }
    }
    
    func getProductWithBarcode(barcode: String) -> ProductoModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "codigoBarras = %@", argumentArray: [barcode])
        var result: ProductoModel?
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                if results.count > 0 {
                    result = parseProductoCoreObjectToProductoModel(coreObject: results.first!)
                }
            } catch {
                print("Error checking the product in database")
            }
        }
        
        return result
    }
    
    func getProductWithProductId(productId: Int64) -> ProductoModel? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "productoId = %@", argumentArray: [productId])
        var result: ProductoModel?
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                if results.count > 0 {
                    result = parseProductoCoreObjectToProductoModel(coreObject: results.first!)
                }
            } catch {
                print("Error checking the product in database")
            }
        }
        
        return result
    }
    
    func deleteProducto(producto: ProductoModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "productoId = %f", argumentArray: [producto.productoId])
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
    
    func deleteAllProductos() {
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
    
    func syncronizeProductosAsync(productos: [ProductoModel]) {
        backgroundContext.perform {
             for producto: ProductoModel in productos {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.TABLE_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "productoId = %f", argumentArray: [producto.productoId])
                let result: NSManagedObject? = try! self.backgroundContext.fetch(fetchRequest).first
                 
                if result != nil {
                    self.setCoreDataObjectDataFromProducto(coreDataObject: result!, producto: producto)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: self.TABLE_ENTITY_NAME, in: self.backgroundContext)
                    let coreProducto = NSManagedObject(entity: entity!, insertInto: self.backgroundContext)
                    self.setCoreDataObjectDataFromProducto(coreDataObject: coreProducto, producto: producto)
                }
             }
             
             try! self.backgroundContext.save()
         }
    }
    
    func syncronizeProductosSync(productos: [ProductoModel]) {
        backgroundContext.performAndWait {
             for producto: ProductoModel in productos {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: TABLE_ENTITY_NAME)
                fetchRequest.predicate = NSPredicate(format: "productoId = %f", argumentArray: [producto.productoId])
                let result: NSManagedObject? = try! backgroundContext.fetch(fetchRequest).first
                 
                if result != nil {
                    setCoreDataObjectDataFromProducto(coreDataObject: result!, producto: producto)
                } else {
                    let entity = NSEntityDescription.entity(forEntityName: TABLE_ENTITY_NAME, in: backgroundContext)
                    let coreProducto = NSManagedObject(entity: entity!, insertInto: backgroundContext)
                    setCoreDataObjectDataFromProducto(coreDataObject: coreProducto, producto: producto)
                }
             }
             
             try! self.backgroundContext.save()
         }
    }
    
    private func parseProductoCoreObjectToProductoModel(coreObject: NSManagedObject) -> ProductoModel {
        let producto: ProductoModel = ProductoModel()
        producto.productoId = coreObject.value(forKey: "productoId") as! Int64
        producto.nombre = coreObject.value(forKey: "nombre") as! String
        producto.numProductos = coreObject.value(forKey: "numProductos") as! Int
        producto.codigoBarras = coreObject.value(forKey: "codigoBarras") as! String
        producto.imagen = coreObject.value(forKey: "imagen") as! String
        producto.comercioId = coreObject.value(forKey: "comercioId") as! Int64
        producto.precio = coreObject.value(forKey: "precio") as! Double
        
        return producto
    }
    
    private func setCoreDataObjectDataFromProducto(coreDataObject: NSManagedObject, producto: ProductoModel) {
        coreDataObject.setValue(producto.productoId, forKey: "productoId")
        coreDataObject.setValue(producto.nombre, forKey: "nombre")
        coreDataObject.setValue(producto.numProductos, forKey: "numProductos")
        coreDataObject.setValue(producto.codigoBarras, forKey: "codigoBarras")
        coreDataObject.setValue(producto.imagen, forKey: "imagen")
        coreDataObject.setValue(producto.comercioId, forKey: "comercioId")
        coreDataObject.setValue(producto.precio, forKey: "precio")
    }
}
