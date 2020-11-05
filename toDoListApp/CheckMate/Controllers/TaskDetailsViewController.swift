//
//  TaskDetailsViewController.swift
//  CheckMate
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

class TaskDetailsViewController: UIViewController, UITextViewDelegate {
    
    var task: ToDoList?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var switchOfDate: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set this VC as delegate of UITextView to respond to changes
        notesTextView.delegate = self
        
        updateSaveButtonState()
        
        // Show Object when user clicks from Table view
        if let task = task {
            navigationItem.title = "Edit Task"
            titleTextField.text = task.title
            isCompleteButton.isSelected = task.isComplete
            dueDatePickerView.date = task.dueDate
            updateDueDateLabel(date: dueDatePickerView.date)
            
            notesTextView.text = task.notes
            if notesTextView.text == "<Additional notes>" {
                notesTextView.textColor = UIColor.lightGray
                notesTextView.font = UIFont.systemFont(ofSize: 13)
            }
            
            //Set title and fields to new ToDo item
        } else {
            navigationItem.title = "New Task"
            if switchOfDate.isOn == true {
                dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
                updateDueDateLabel(date: dueDatePickerView.date)
            }
            notesTextView.text = "<Additional notes>"
            notesTextView.textColor = UIColor.lightGray
            notesTextView.font = UIFont.systemFont(ofSize: 13)
        }
        
        dueDatePickerView.isEnabled = false
        dueDateLabel.isHidden = true
    }
    
    // Switch between enabling or disabling the datePicker
    @IBAction func switchDate(_ sender: UISwitch) {
        if sender.isOn {
            dueDatePickerView.isEnabled = true
            dueDateLabel.isHidden = false
        }else{
            dueDatePickerView.isEnabled = false
            dueDateLabel.isHidden = true
        }
    }
    
    // MARK: - Helpers functions
    
    
    // Toggle completed button image
    @IBAction func isCompletedButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
        updateSaveButtonState()
    }
    
    // Detect if user begins editing inside UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "<Additional notes>" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    // Built-in method to detect when user edits text in TextView
    func textViewDidChangeSelection(_ textView: UITextView) {
        print(textView.text ?? "")
        updateSaveButtonState()
    }
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    // Method to detect inputs into UITextField
    @IBAction func textFieldEdited(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Dismiss Keyboard when Return key is pressed
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    // Dismiss Keyboard when view is pressed
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    // Update Save Button method based on text present or not in TextField
    func updateSaveButtonState() {
        let titleText = titleTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty
    }
    
    // MARK: - Set date functions
    
    // Update the DueDate label as the Date Picker changes
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
    }
    
    //Update Due Date Label with Date entered from Date picker
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDoList.dueDateFormatter.string(from: date)
    }
    
    // MARK: - Pass data with prepare for sender function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "save" else { return }
        
        // Save to DataBase...
        guard let title = titleTextField.text else {return}
        guard let duedate = dueDateLabel.text else {return}
        guard let note = notesTextView.text else {return}
        
        let taskInfo = TaskService.Task(title: title, dueDate: duedate, notes: note)
        
        TaskService.shared.uploadTask(task: taskInfo) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to save task with error \(error.localizedDescription)")
                return
            }
        }
        
        //Set values
        let titleText = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        //Create a task object
        task = ToDoList(title: titleText, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
    
    
}
