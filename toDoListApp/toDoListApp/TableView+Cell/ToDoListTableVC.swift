//
//  ToDoListTableVC.swift
//  toDoListApp
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

class ToDoListTableVC: UITableViewController, ToDoListCellDelegate {
    
    var tasks = [ToDoList]()
    
    var test: TaskDetailsViewController?
    
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "save" else { return }
        let sourceVC = segue.source as! TaskDetailsViewController
        
        if let task = sourceVC.task {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tasks[selectedIndexPath.row] = task
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: tasks.count, section: 0)
                tasks.append(task)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Title
        title = "To-Do List"
        
        navigationItem.leftBarButtonItem = editButtonItem
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDolistCell
        
        cell.delegate = self
        
        // Configure the cell...
        let task = tasks[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.isCompleteButton.isSelected = task.isComplete
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    // Override to support conditional editing of the table view
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Override to support conditional rearranging of the table view
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // Move a row from specific location to another one
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {return}
        
        let movedItem = tasks[fromIndex]
        tasks.remove(at: fromIndex)
        tasks.insert(movedItem, at: toIndex)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            let todoViewController = segue.destination as! TaskDetailsViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = tasks[indexPath.row]
            todoViewController.task = selectedTodo
        }
    }
    
    // MARK: - Handle the checkMark for completed tasks
    
    // Determine index path of the cell to update the checkmark when set
    func completeButtonTapped(sender: ToDolistCell) {
        
        if let indexPath = tableView.indexPath(for: sender) {
            var task = tasks[indexPath.row]
            task.isComplete = !task.isComplete
            tasks[indexPath.row] = task
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}

