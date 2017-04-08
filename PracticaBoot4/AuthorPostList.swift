//
//  AuthorPostList.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class AuthorPostList: UITableViewController {

    var postRef : FIRDatabaseReference!

    
    let cellIdentifier = "POSTAUTOR"
    
    var model : [Posts] = []
    var user : FIRUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.refreshControl?.addTarget(self, action: #selector(hadleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFireBase()
        pullModel()
    }
    
    func hadleRefresh(_ refreshControl: UIRefreshControl) {
        pullModel()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = model[indexPath.row].title
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let ref = self.model[indexPath.row].refInCloud

        
        let publish = UITableViewRowAction(style: .normal, title: "Publicar") { (action, indexPath) in
            // Codigo para publicar el post
            ref?.updateChildValues(["status" : true], withCompletionBlock: { (error, ref) in
                if let _ = error{
                    self.showAlert(message: "Error al eliminar una noticia")
                }
                self.model[indexPath.row].status = true
                self.tableView.reloadData()

            })
            self.tableView.cellForRow(at: indexPath)?.reloadInputViews()

        }
        publish.backgroundColor = UIColor.green
        
        let unPublish = UITableViewRowAction(style: .normal, title: "Despublicar") { (action, indexPath) in
            // Codigo para publicar el post
            ref?.updateChildValues(["status" : false], withCompletionBlock: { (error, ref) in
                if let _ = error{
                    self.showAlert(message: "Error al eliminar una noticia")
                }
                self.model[indexPath.row].status = false
                self.tableView.reloadData()
                
            })
            self.tableView.cellForRow(at: indexPath)?.reloadInputViews()

            
            
        }
        unPublish.backgroundColor = UIColor.orange
        
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            // codigo para eliminar
            ref?.removeValue(completionBlock: { (error, ref) in
                if let _ = error{
                    self.showAlert(message: "Error al eliminar una noticia")
                    return
                }
                self.model.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
            self.tableView.cellForRow(at: indexPath)?.reloadInputViews()

            
        }

        if self.model[indexPath.row].status {
            return [unPublish, deleteRow]
        }else{
            return [publish, deleteRow]
        }
    }

   

    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewPost"{
            let vc = segue.destination as! NewPostController
            vc.user = self.user
        }
    }

}




//MARK: - Firebase métodos
extension AuthorPostList {
    
    func setupFireBase(){
        FIRAnalytics.setScreenName("Noticias de autor", screenClass: "AuthorPostList")

        postRef = FIRDatabase.database().reference().child("Posts")
        
    }
    
    func pullModel(){
        
        postRef.observe(.childAdded, with: { (snap) in
            print(snap)
            //Construyo modelo
            self.model = []
            for post in snap.children{
                let aPost = Posts(snap: post as? FIRDataSnapshot)
                self.model.append(aPost)
            }
            self.model = self.model.filter({$0.author == self.user?.email})
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
        
        
    }
    
    
    
}







