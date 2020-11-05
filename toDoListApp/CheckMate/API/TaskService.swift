//
//  TweetService.swift
//  twitter
//
//  Created by Jawaher Alagel on 11/1/20.
//

import Firebase

struct TaskService {
    static let shared = TaskService()
    
    struct Task {
    var title: String
    var dueDate: String
    var notes: String
    }
    
    func uploadTask(task: Task, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let title = task.title
        let dueDate = task.dueDate
        let notes = task.notes
        
        let values = ["title": title,
                      "dueDate": dueDate,
                      "notes": notes]
        
        refTweets.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        print("DEBUG: user info: \(values)")

    }
    
    
    
}
