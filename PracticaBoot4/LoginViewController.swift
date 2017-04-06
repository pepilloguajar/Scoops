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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


    @IBAction func doAnonimoLogin(_ sender: Any) {
        makeLogout()
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let _ = error {
                print(error?.localizedDescription)
                return
            }
            print(user?.uid)
            self.performSegue(withIdentifier: "loginOk", sender: nil)

        })
    }
    
    @IBAction func doFacebookLogin(_ sender: Any) {
    }
    

    //MARK: - Utils
    fileprivate func makeLogout() {
        if let _ = FIRAuth.auth()?.currentUser {
            do{
                try FIRAuth.auth()?.signOut()
            }catch let error {
                print(error)
            }
        }
    }

}
