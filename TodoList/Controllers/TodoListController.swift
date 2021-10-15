//
//  ViewController.swift
//  TodoList
//
//  Created by Ahmed Adel Al-Ahmed on 04/10/2021.
//

import UIKit

class TodoListController: UITableViewController, TaskCellDelegate {
    
    let cellId = "taskCell"
    
    var tasks: [Task] = [
        Task(title: "Take a shower"),
        Task(title: "Make a cup of coffee"),
        Task(title: "Have a breakfast"),
        Task(title: "Read 3 pages from superfans book"),
        Task(title: "Clean the room")
    ]
    var filteredTasks = [Task]()
    var appliedFilter: TaskFilter = .uncompleted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting navigation bar title
        title = "Todo"
        
        // Setting add task button in navigation ber, and call addTaskButtonClicked when tapped
        let addTaskButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
        let filterTasksButton = UIBarButtonItem(image: UIImage(systemName: "viewfinder.circle"), style: .plain, target: self, action: #selector(filterTasksButtonTapped))
        navigationItem.rightBarButtonItems = [addTaskButton, filterTasksButton]
        
        // Setting footer view to empty view to hide extra cell separators
        tableView.tableFooterView = UIView()
        
        // Add tasks to filtered tasks
        switch appliedFilter {
        case .completed:
            filteredTasks = tasks.filter({ $0.isCompleted })
        case .uncompleted:
            filteredTasks = tasks.filter({ !$0.isCompleted })
        default:
            filteredTasks = tasks
        }
    }
        
    @objc private func addTaskButtonTapped() {
        // Create alert controller
        let alert = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        
        // Add text field for the task name
        alert.addTextField { textField in
            textField.placeholder = "What do you want to do?"
        }
        
        // Add actions/buttons
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] action in
            // Create the task
            
            if let textFields = alert.textFields, let taskName = textFields[0].text, !taskName.isEmpty {
                self?.addNewTask(withName: taskName)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Display the alert
        present(alert, animated: true, completion: nil)
    }
    
    private func addNewTask(withName name: String) {
        
        // Create the new task
        let task = Task(title: name)
        
        // Add task to the array
        self.tasks.append(task)
        
        // If incomplete tasks should be shown, add the task to filteredTasks
        if appliedFilter != .completed {
            self.filteredTasks.append(task)
            // Insert the task in tableView
            tableView.insertRows(at: [IndexPath(row: tasks.count - 1, section: 0)], with: .automatic)
        }
    }
    
    @objc private func filterTasksButtonTapped() {
        let sheet = UIAlertController(title: "Filter by status", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "All", style: .default, handler: { [weak self] _ in
            self?.filterTasks(filter: .all)
        }))
        sheet.addAction(UIAlertAction(title: "Not completed", style: .default, handler: { [weak self] _ in
            self?.filterTasks(filter: .uncompleted)
        }))
        sheet.addAction(UIAlertAction(title: "Completed", style: .default, handler: { [weak self] _ in
            self?.filterTasks(filter: .completed)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true, completion: nil)
    }
    
    private func filterTasks(filter: TaskFilter) {
        appliedFilter = filter
        
        switch filter {
        case .completed:
            filteredTasks = tasks.filter({ $0.isCompleted })
        case .uncompleted:
            filteredTasks = tasks.filter({ !$0.isCompleted })
        default:
            filteredTasks = tasks
        }
        
        tableView.reloadData()
    }
}

extension TodoListController {
    // Specify that the table view has one section only
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Return the number of cells that the table view should show
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    // Return the table view cell with task name displayed
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskCell
        
        // Set task name to be displayed
        cell.task = filteredTasks[indexPath.item]
        
        // Set the delegate
        cell.delegate = self
        
        // Return the cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = filteredTasks[indexPath.item]
            filteredTasks.remove(at: indexPath.item)
            
            // Get the task index in tasks array in case it is different than
            // the index in filtered array
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks.remove(at: index)
            }
            
            // Delete the row
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Implementing task cell delegate function
    func updateTask(task: Task) {
        // Getting the index of the updated task
        if let index = filteredTasks.firstIndex(where: { $0.id == task.id }) {
            // Remove the task from table view if it does not match the filter
            if appliedFilter == .uncompleted && task.isCompleted || appliedFilter == .completed && !task.isCompleted {
                filteredTasks.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            } else {
                // Updating the task in filtered tasks array
                filteredTasks[index] = task
            }
        }
        
        // Getting the index of the updated task
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            // Updating the task in tasks array
            tasks[index] = task
        }
    }
}
