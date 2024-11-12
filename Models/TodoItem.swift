//
//  TodoItem.swift
//  MY_Uppgift4
//
//  Created by elias on 2024-11-12.
//
import Foundation
import SwiftData

@Model
class TodoItem: Identifiable {
    var id: String
    var todoName: String
    var todoDescription: String
    var todoDeadline: Date
    var timestamp: Date
    var completed: Date?

    init(id: String, todoName: String, todoDescription: String, todoDeadline: Date, timestamp: Date, completed: Date? = nil) {
        self.id = id
        self.todoName = todoName
        self.todoDescription = todoDescription
        self.todoDeadline = todoDeadline
        self.timestamp = timestamp
        self.completed = completed
    }
}
