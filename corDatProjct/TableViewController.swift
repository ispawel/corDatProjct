//
//  TableViewController.swift
//  corDatProjct
//
//  Created by Pavel Isakov on 02.03.2022.
//

import UIKit
import CoreData



class TableViewController: UITableViewController {
    
    
    var tasks: [Tasks] = []

    
    
    
    //кнопка и функция удаления задачи
    @IBAction func deleteTasks(_ sender: UIBarButtonItem) {
       
        
        //доступ до контекста
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //запрос на удаление
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        //проверка запроса и удалние
        if let tasks = try? context.fetch(fetchRequest){
            for task in tasks {
                context.delete(task)
            }
        }
        
        
        //Перезапись контекста после удаление
        do {
            try context.save()
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
    
        tableView.reloadData()
    }
    
    
    
    
    //кнопка добавление новой задачи и создание окна
    @IBAction func addTasks(_ sender: UIBarButtonItem) {
        
        //создание контроллера уведомления
        let alertController = UIAlertController(title: "Добавление новой задачи", message: "Введите задачу", preferredStyle: .alert)
        
        
        let saveTask = UIAlertAction(title: "Сохранить", style: .default) { action in
            let textField = alertController.textFields?.first
           
            
            //проверка опционала и запись через вызов метода, обновление View
            if let newTask = textField?.text{
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
            
        }
        
        
        
        alertController.addTextField { _ in }
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in }
        
        
        alertController.addAction(saveTask)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    // запись данных в core data
    func saveTask(withTitle title: String) {
        
        
        // доступ к контексту
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        //доступ к сущности
        guard let enitity = NSEntityDescription.entity(forEntityName: "Tasks", in: context) else { return }
        
        
        //доступ к обьекту
        let taskOdject = Tasks(entity: enitity, insertInto: context)
        taskOdject.title = title
        
        
        
        //запись в CoreData
        
        do {
            try context.save()
            tasks.append(taskOdject)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        
        
        
        do {
            tasks = try context.fetch(fetchRequest)
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        return cell
    }
    

   
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
