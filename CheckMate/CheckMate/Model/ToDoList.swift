//
//  ToDoList.swift
//  CheckMate
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

struct ToDoList: Codable {
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
    
    // MARK: - Data persistance
    
    // Saving / reading data entered in the app
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
        .appendingPathExtension("plist")
    
    // Method to saves data to disk
    static func saveTasks(_ tasks: [ToDoList]) {
        let encoder = PropertyListEncoder()
        
        let codedTasks = try? encoder.encode(tasks)
        try? codedTasks?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    // Method to loads the saved data from disk
    static func loadTasks() -> [ToDoList]?  {
        guard let codedTasks = try? Data(contentsOf: ArchiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([ToDoList].self, from: codedTasks)
    }
    
}
