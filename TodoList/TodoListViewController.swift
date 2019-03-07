//
//  TodoListViewController.swift
//  TodoList
//
//  Created by pangthunyalak on 7/3/2562 BE.
//  Copyright © 2562 pangthunyalak. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoListViewController: UIViewController {

    
    // MARK: IBOUTLET Properties
    @IBOutlet weak var tableView: UITableView!
    private var databaseReference: DatabaseReference!
    
    static let segueIdentifier = "todoListGoToAddItem"
    static let cellIdentifier = "TodoListCell"
    var todoListDataSource = [String]()
    
    // MARK: View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearTodoListDataSource()
        fetchDataFromDatabase { [weak self] (todoItems) in
            self?.todoListDataSource.append(contentsOf: todoItems)
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func clearTodoListDataSource() {
        self.todoListDataSource = [String]()
    }
    
    private func fetchDataFromDatabase(completion: @escaping (_ data: [String])-> Void) {
        self.databaseReference = Database.database().reference()
        var tempTodo = [String]()

        self.databaseReference.child("TodoList2").observeSingleEvent(of: .value) { (dataSnapshot) in
            for child in dataSnapshot.children {
                if let item = child as? DataSnapshot,
                    let value = item.value as? String {
                    tempTodo.append(value)
                }
            }
            completion(tempTodo)
        }
    }
    
    @IBAction func AddItemClicked(_ sender: Any) {
        self.performSegue(withIdentifier: TodoListViewController.segueIdentifier, sender: nil)
    }
    
}

//MARK: - UITableViewDataSource
extension TodoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoListViewController.cellIdentifier, for: indexPath)
        let todo = todoListDataSource[indexPath.row]
        cell.textLabel?.text = todo
        return cell
    }
}

//MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            completion(true)
        }
//        action.image = trush
        action.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [action])
    }
   
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action, view, completion) in
            completion(true)
        }
//        action.image = check
        action.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [action])
    }

