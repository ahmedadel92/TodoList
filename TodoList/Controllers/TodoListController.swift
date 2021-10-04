//
//  ViewController.swift
//  TodoList
//
//  Created by Ahmed Adel Al-Ahmed on 04/10/2021.
//

import UIKit

class TodoListController: UITableViewController, TaskCellDelegate {
    
    let cellId = "taskCell"
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting navigation bar title
        title = "Todo"
        
        // Setting add task button in navigation ber, and call addTaskButtonClicked when tapped
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonClicked))
        navigationItem.rightBarButtonItem = addTaskButton
        
        // Setting footer view to empty view to hide extra cell separators
        tableView.tableFooterView = UIView()
    }
        
    @objc private func addTaskButtonClicked() {
        // Create alert controller
        let alert = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        
        // Add text field for the task name
        alert.addTextField { textField in
            textField.placeholder = "What do you want to do?"
        }
        
        // Add actions/buttons
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] action in
            // Create the task
            
            if let textFields = alert.textFields, let taskName = textFields[0].text {
                self?.addNewTask(withName: taskName)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Display the alert
        present(alert, animated: true, completion: nil)
    }
    
    private func addNewTask(withName name: String) {
        // Add task to the array
        self.tasks.append(Task(title: name))
        
        // Insert the task in tableView
        tableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
    }
}

extension TodoListController {
    // Specify that the table view has one section only
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of cells that the table view should show
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    // Return the table view cell with task name displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
        
        // Set task name to be displayed
        cell.task = tasks[indexPath.item]
        
        // Set the delegate
        cell.delegate = self
        
        // Return the cell
        return cell
    }
    
    // Implementing task cell delegate function
    func updateTask(task: Task) {
        // Getting the index of the updated task
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // Updating the task in tasks array
            tasks[index] = task
        }
    }
}
