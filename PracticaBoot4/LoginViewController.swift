//
//  LoginViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 6/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var handle: FIRAuthStateDidChangeListenerHandle!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if user != nil{
                self.performSegue(withIdentifier: "loginOk", sender: nil)
            }

        })
        
    }


    @IBAction func doAnonimoLogin(_ sender: Any) {
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let _ = error {
                print(error?.localizedDescription)
                return
            }
            print(user?.uid)
            //self.performSegue(withIdentifier: "loginOk", sender: nil)

        })
    }
    


    

}
