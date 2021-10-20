//
//  RealmVC.swift
//  ToDoList
//
//  Created by Александр Жуков on 29.09.2021.
//

import UIKit

class RealmVC: UIViewController {
    
    let realm = RealmInstance()
    var actionToEnable: UIAlertAction?
        
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        self.tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create new task", message: "Enter task name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?.first, let text = textField.text else {
                return
            }
            
            let newTask = Task()
            newTask.name = text
            self?.realm.addNewTask(task: newTask)
            self?.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Task name..."
            alertTextField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.actionToEnable = okAction
        okAction.isEnabled = false
        present(alert, animated: true)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled  = (sender.text! != "")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm.refreshData()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

}

extension RealmVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "realm") as! RealmCell

        cell.nameLabel.text = realm.data[indexPath.row].name
        
        if !realm.data[indexPath.row].isCompleted {
                cell.accessoryType = .none
            } else if realm.data[indexPath.row].isCompleted {
                cell.accessoryType = .checkmark
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            realm.deleteTask(task: realm.data[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        realm.complete(task: realm.data[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        realm.changePosition(source: sourceIndexPath.row, destination: destinationIndexPath.row)
    }
}


extension RealmVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            realm.refreshData()
        } else {
            realm.data = realm.data?.filter("name CONTAINS[cd] %@", searchBar.text!)
        }
        tableView.reloadData()
    }
}

