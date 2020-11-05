//
//  ToDoListTableVC.swift
//  toDoListApp
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

class ToDoListTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ToDoListCellDelegate {
    
    var tasks = [ToDoList]()
    
    let plusButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.backgroundColor = .white
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 65 / 2
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showDetails(_ :)), for: .touchUpInside)
        return button
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewCorner: UIView!
    
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
        ToDoList.saveTasks(tasks)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // Set edit button
        let leftButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(showEditing(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set cornerRadius..
        tableView.roundCorners([.topRight], radius: 100)
        viewCorner.roundCorners([.bottomLeft, .bottomRight], radius: 50)
        
        //Set Title
        title = "To-Do List"
        definesPresentationContext = true
        
        // Load any saved data from disk
        if let savedTasks = ToDoList.loadTasks() {
            tasks = savedTasks
        }else{
            return
        }
    }
    
    // MARK: - Selectors and helper functions
    
    @objc func showDetails(_ : UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "TaskDetailsViewController") as! TaskDetailsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showEditing(_ sender: UIBarButtonItem) {
        if (self.tableView.isEditing == true) {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }else{
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    func configureUI() {
        view.addSubview(plusButton)
        
        plusButton.topAnchor.constraint(equalTo: viewCorner.bottomAnchor, constant: -30).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDolistCell
        
        cell.delegate = self
        
        // Configure the cell...
        let task = tasks[indexPath.row]
        
        cell.titleLabel.text = task.title
        cell.isCompleteButton.isSelected = task.isComplete
        
        // Display dueDate
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: Date(), to: task.dueDate)
        let dayDifference = components.day!
        let hourDifference = components.hour!
        let minuteDifference = components.minute!
        
        if dayDifference <= 0 {
            cell.dueDateLabel.text = "Due in about (\(hourDifference))hours, (\(minuteDifference))mins"
        } else if hourDifference <= 0 {
            cell.dueDateLabel.text = "Due in about (\(minuteDifference))mins"
        }else{
            cell.dueDateLabel.text = "Due in about (\(dayDifference))days, (\(hourDifference))hours, (\(minuteDifference))mins"
        }
        
        // If the task is past due, make textColor red
        if dayDifference <= 0, minuteDifference <= 0, hourDifference <= 0 {
            cell.dueDateLabel.textColor = .red
        }else{
            cell.dueDateLabel.textColor = .black
        }
        
        return cell
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDoList.saveTasks(tasks)
        }    
    }
    
    // Support conditional editing of the table view
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Support conditional rearranging of the table view
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // Move a row from specific location to another one
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {return}
        
        let movedItem = tasks[fromIndex]
        tasks.remove(at: fromIndex)
        tasks.insert(movedItem, at: toIndex)
        ToDoList.saveTasks(tasks)
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
    
    // MARK: - Extentions
    
    // Determine index path of the cell to update the checkmark when set
    func completeButtonTapped(sender: ToDolistCell) {
        
        if let indexPath = tableView.indexPath(for: sender) {
            var task = tasks[indexPath.row]
            task.isComplete = !task.isComplete
            tasks[indexPath.row] = task
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDoList.saveTasks(tasks)
        }
    }
    
}

// Set cornerRadius of UIView
extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .second, value: 0, to: date) else { break }
            date = newDate
        }
        return dates
    }
}
