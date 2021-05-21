//
//  TableViewController.swift
//  ToDoList
//
//  Created by 山本響 on 2021/05/16.
//

import UIKit

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    var toDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()!
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
            fatalError("Could not dequeue a cell")
        }
        
        cell.delegate = self
        
        let todo = toDos[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDos.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt
    indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(toDos)
        }
    }
    
    @IBAction func unwindToTodoList(seque: UIStoryboardSegue) {
        guard seque.identifier == "saveUnwind" else { return }
        let sourceViewController = seque.source as! ToDoViewController
        
        if let todo = sourceViewController.todo {
            if let selecterdIndexPath = tableView.indexPathForSelectedRow {
                toDos[selecterdIndexPath.row] = todo
                tableView.reloadRows(at: [selecterdIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                
                toDos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(toDos)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("**prepare*")
        if segue.identifier == "showDetails" {
            if let destVC = segue.destination as? UINavigationController,
               let todoViewController = destVC.topViewController as? ToDoViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                let selectedTodo = toDos[indexPath.row]
                todoViewController.todo = selectedTodo
            }
        }
    }

    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = toDos[indexPath.row]
            todo.isComplete = !todo.isComplete
            toDos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }

}
