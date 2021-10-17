//
//  RealmInstance.swift
//  ToDoList
//
//  Created by Александр Жуков on 30.09.2021.
//

import Foundation
import RealmSwift

class RealmInstance {
    
    let realm = try! Realm()
    var data: Results<Task>!
    
    
    func addNewTask(task: Task){
            try! self.realm.write{
                realm.add(task)
            }
        refreshData()
        }
        
    func deleteTask(task: Task){
        try! self.realm.write{
            realm.delete(task)
        }
        refreshData()
    }
    
    func complete(task: Task) {
        try! self.realm.write {
            task.isCompleted = !task.isCompleted
        }
        refreshData()
    }
    
    func changePosition(source: Int, destination: Int) {
        try! realm.write {
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
        data = realm.objects(Task.self).sorted(byKeyPath: "position", ascending: true)
    }
}
