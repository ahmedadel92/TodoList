//
//  TaskCell.swift
//  TodoList
//
//  Created by Ahmed Adel Al-Ahmed on 04/10/2021.
//

import UIKit

protocol TaskCellDelegate {
    func updateTask(task: Task)
}

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeTaskButton: UIButton!
    
    var delegate: TaskCellDelegate?
    
    var task: Task? {
        didSet {
            guard let task = task else { return }
            titleLabel.text = task.title
            completeTaskButton.setImage(UIImage(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle"), for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func completeTaskButtonTapped(_ sender: UIButton) {
        guard let _ = task else { return }
        task!.isCompleted.toggle()
        completeTaskButton.setImage(UIImage(systemName: task!.isCompleted ? "checkmark.circle.fill" : "circle"), for: .normal)
        completeTaskButton.tintColor = UIColor.systemBlue.withAlphaComponent(task!.isCompleted ? 0.25 : 1)
        titleLabel.textColor = UIColor.label.withAlphaComponent(task!.isCompleted ? 0.25 : 1)
    }
}
