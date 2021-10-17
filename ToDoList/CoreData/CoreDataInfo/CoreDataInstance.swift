//
//  CoreDataInstance.swift
//  ToDoList
//
//  Created by Александр Жуков on 12.10.2021.
//

import CoreData
import Foundation

struct CoreDataInstance {
        
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    var data: [TaskCD] {
        let request = NSFetchRequest<TaskCD>(entityName: "TaskCD")
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func addNewTask(with name: String) {
        let task = NSEntityDescription.insertNewObject(forEntityName: "TaskCD", into: persistentContainer.viewContext)
        task.setValue(name, forKey: "name")
        task.setValue(data.count, forKey: "position")
        
        refreshData()
    }
    
    func deleteTask(with name: String) {
        let fetchRequest: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", name])
        
        do {
            guard let task = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            persistentContainer.viewContext.delete(task)
            refreshData()
        }
        catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func complete(with name: String) {
        let fetchRequest: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", name])
        
        do {
            guard let task = try persistentContainer.viewContext.fetch(fetchRequest).first else {
                return
            }
            task.isCompleted = !task.isCompleted
            refreshData()
        }
        catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func changePosition(name: String, source: Int, destination: Int) {
        
        let fetchRequest: NSFetchRequest<TaskCD> = TaskCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["name", name])

        do {

            let sourceObject = data[source]
            let destinationObject = data[destination]

            let destinationObjectOrder = destinationObject.position

            if source < destination {
                for index in source...destination {
                    let object = data[index]
                    object.position -= 1
                }
            } else {
                for index in (destination..<source).reversed() {
                    let object = data[index]
                    object.position += 1
                }
            }
            sourceObject.position = destinationObjectOrder
        }
        
        refreshData()
    }
       

    func refreshData() {
        do {
            try persistentContainer.viewContext.save()

        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}
