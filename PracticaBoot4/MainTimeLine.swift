//
//  MainTimeLine.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class MainTimeLine: UITableViewController {
    
    var postRef : FIRDatabaseReference!
    var handle: FIRAuthStateDidChangeListenerHandle!


    var model : [Posts] = []
    let cellIdentier = "POSTSCELL"
    
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
        self.setupFireBase()
        self.pullModel()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentier, for: indexPath)

        cell.textLabel?.text = model[indexPath.row].title


        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowRatingPost", sender: indexPath)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowRatingPost" {
            let vc = segue.destination as! PostReview
            // aqui pasamos el item selecionado
            let index = (sender as! IndexPath).row
            vc.model = model[index]
            print(vc.model.title)
        }
    }


}

//MARK: - Firebase métodos
extension MainTimeLine {
    
    func setupFireBase(){
        postRef = FIRDatabase.database().reference().child("Posts")
        
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            guard let user = user else {return}
            if (user.isAnonymous){
                print("El usuario ANONIMO logado es \(user.uid)")
            }else{
                print("El usuario logado es \(user.uid)")
            }
        })
        
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
            self.model = self.model.filter({$0.status})
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
        
        postRef.observe(.childChanged, with: { (snap) in
            print(snap)
            //Construyo modelo
            self.model = []
            for post in snap.children{
                let aPost = Posts(snap: post as? FIRDataSnapshot)
                self.model.append(aPost)
            }
            
            self.model = self.model.filter({$0.status})

            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }) { (error) in
            print(error)
        }
        
        
    }
    
    
    
}





