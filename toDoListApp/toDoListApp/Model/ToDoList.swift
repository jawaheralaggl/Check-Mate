//
//  ToDoList.swift
//  toDoListApp
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

struct ToDoList {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    // Date formatter Object
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter
    }()
    
}
