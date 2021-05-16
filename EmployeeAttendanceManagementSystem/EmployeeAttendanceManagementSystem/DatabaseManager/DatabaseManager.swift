//
//  DatabaseManager.swift
//  EmployeeAttendanceManagementSystem
//
//  Created by Waseem Wani on 25/04/21.
//

import Foundation
import CoreData

enum CoreDataModelType<T> {
    
    case officeLocation
    case user
    case userById(Int16)
    case checkIn
    case checkInByDate(String)
    case checkOut
    case checkOutByDate(String)

    
    var discriptorKey: String? {
        switch self {
            case .userById:
                return "employeeId"
            case .checkInByDate, .checkOutByDate:
                return "date"
            default:
                return nil
        }
    }
    
    var predicate: String? {
        switch self {
            case .userById(let empId):
                return String(empId)
            case .checkInByDate(let date), .checkOutByDate(let date):
                return date
            default:
                return nil
        }
    }
    
    var resultType : T.Type {
        switch self {
            case .officeLocation, .user:
                return T.self
            default:
                return T.self
        }
    }
}

// this class manages different database operations
class DatabaseManager {
    
    static let sharedInstance = DatabaseManager() //singleton class, shared instance
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmployeeAttendanceManagementSystem")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    var appDBContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveData<T>(modelType: CoreDataModelType<T>, completion: @escaping((T) -> Void)) {
        let entityName = String(describing: modelType.resultType)
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: appDBContext) as! T
        let result = (entity)
        completion(result)
        saveContext()
    }
    
    func saveContext () {
        if appDBContext.hasChanges {
            do {
                try appDBContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            //            do {
            //                try? appDBContext.save()
            //            }
            
        }
    }
    
    func retrieveData<T: NSManagedObject>(modelType: CoreDataModelType<T>) -> [T]? {
        let entity = String(describing: modelType.resultType)
        let fetchRequest = NSFetchRequest<T>(entityName: entity)
        if let key = modelType.discriptorKey {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: key, ascending: true)]
            if let predicate = modelType.predicate {
                fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: [key, predicate])
            }
        }
        let result = try? appDBContext.fetch(fetchRequest)
        return result
    }
    
    func deleteData<T>(modelType: CoreDataModelType<T>) {
        let entity =  String(describing: modelType.resultType)
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            _ = try? appDBContext.execute(deleteRequest)
            try? appDBContext.save()
        }
    }
    
    func getRecordsCount<T: NSManagedObject>(modelType: CoreDataModelType<T>) -> Int {
        let entity = String(describing: modelType.resultType)
        let fetchRequest = NSFetchRequest<T>(entityName: entity)
        let key = modelType.discriptorKey ?? ""
        if let predicate = modelType.predicate {
            fetchRequest.predicate = NSPredicate(format: "\(key) == \(predicate)")
        }
        do {
            let count = try? appDBContext.count(for: fetchRequest)
            return count!
        }
    }
    
}
