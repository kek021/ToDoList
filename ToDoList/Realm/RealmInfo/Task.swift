//
//  Task.swift
//  ToDoList
//
//  Created by Александр Жуков on 30.09.2021.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var position: Int = 0
}

