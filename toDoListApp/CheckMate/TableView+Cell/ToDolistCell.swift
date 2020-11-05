//
//  ToDolistCell.swift
//  CheckMate
//
//  Created by Jawaher Alagel on 11/3/20.
//

import UIKit

protocol ToDoListCellDelegate: class {
    
    func completeButtonTapped(sender: ToDolistCell)
}

class ToDolistCell: UITableViewCell {
    
    // Delegate property
    var delegate: ToDoListCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBAction func isCompleteButtonTapped() {
        delegate?.completeButtonTapped(sender: self)
    }
    
    
}
