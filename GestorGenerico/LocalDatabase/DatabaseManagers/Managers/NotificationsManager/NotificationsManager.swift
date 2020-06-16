//
//  NotificationsManager.swift
//  GestorHeme
//
//  Created by jon mikel on 09/04/2020.
//  Copyright © 2020 jon mikel. All rights reserved.
//

import UIKit
import CoreData

class NotificationsManager: NSObject {
    let NOTIFICATIONS_ENTITY_NAME: String = "Notifications"
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
    
    func getAllNotificationsFromDatabase() -> [NotificationModel] {
        var notifications: [NotificationModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    notifications.append(databaseHelper.parseNotificationCoreObjectToNotificationModel(coreObject: data))
                }
            } catch {
            }
        }

        return notifications
    }
    
    func addNotificationToDatabase(newNotification: NotificationModel) {
        let entity = NSEntityDescription.entity(forEntityName: NOTIFICATIONS_ENTITY_NAME, in: backgroundContext)
        
        if getNotificationFromDatabase(notificationId: newNotification.notificationId).count == 0 {
            let coreService = NSManagedObject(entity: entity!, insertInto: backgroundContext)
            databaseHelper.setCoreDataObjectDataFromNotification(coreDataObject: coreService, newNotification: newNotification)
            backgroundContext.performAndWait {
                do {
                    try backgroundContext.save()
                } catch {
                }
            }
            
            DispatchQueue.main.async {
                Constants.rootController.setNotificationBarItemBadge()
            }
        }
    }
    
    func getNotificationFromDatabase(notificationId: Int64) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "notificationId = %f", argumentArray: [notificationId])
        var results: [NSManagedObject] = []
        
        mainContext.performAndWait {
            do {
                results = try mainContext.fetch(fetchRequest)
            } catch {
            }
        }
        
        return results
    }
    
    func markNotificationAsRead(notification: NotificationModel) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "notificationId = %f", argumentArray: [notification.notificationId])
        var results: [NSManagedObject] = []
        
        backgroundContext.performAndWait {
            do {
                results = try backgroundContext.fetch(fetchRequest)
                if results.count > 0 {
                    let coreNotification: NSManagedObject = results.first!
                    coreNotification.setValue(notification.leido, forKey: "leido")
                }
                try backgroundContext.save()
            } catch {
            }
        }
    }
    
    func getAllNotificationsForClientAndNotificationType(notificationType: String, clientId: Int64) -> [NotificationModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type = %@", argumentArray: [notificationType])
        var notifications: [NotificationModel] = []
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    let notiClientId: Int64 = data.value(forKey: "clientId") as! Int64
                    if notiClientId == clientId {
                        let notification: NotificationModel = databaseHelper.parseNotificationCoreObjectToNotificationModel(coreObject: data)
                        notifications.append(notification)
                        
                    }
                }
                
                try mainContext.save()
            } catch {
            }
        }
        
        return notifications
    }
    
    func getAllNotificationsForType(type: String) -> [NotificationModel] {
        var notifications: [NotificationModel] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type = %@", argumentArray: [type])

        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    notifications.append(databaseHelper.parseNotificationCoreObjectToNotificationModel(coreObject: data))
                }
            } catch {
            }
        }

        return notifications
    }
    
    func updateNotificationsForClientAndType(notificationType: String, clientId: Int64) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "type = %@", argumentArray: [notificationType])
        var result: Bool = false
        mainContext.performAndWait {
            do {
                let results: [NSManagedObject] = try mainContext.fetch(fetchRequest)
                for data in results {
                    let clientIds: [Int64] = data.value(forKey: "clientId") as! [Int64]
                    data.setValue(clientIds.filter {$0 != clientId}, forKey: "clientId")
                }
                
                result = true
                try mainContext.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    func eliminarNotificacion(notificationId: Int64) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
        fetchRequest.predicate = NSPredicate(format: "notificationId = %f", argumentArray: [notificationId])
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
    
    func deleteAllNotifications() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: NOTIFICATIONS_ENTITY_NAME)
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
}
