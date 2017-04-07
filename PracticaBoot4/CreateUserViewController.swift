//
//  CreateUserViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 6/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class CreateUserViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }


    @IBAction func doRegistro(_ sender: Any) {
        
        guard let email = emailText.text, let pass = passText.text else {
            self.showAlert(message: "Rellena todos los campos")
            return
        }
        
        if email.isEmpty || pass.isEmpty{
            self.showAlert(message: "Rellena todos los campos")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
            if let _ = error {
                print(error?.localizedDescription)
                self.showAlert(message: (error?.localizedDescription)!)
                return
            }else{
                print("\(user?.email)")
                self.performSegue(withIdentifier: "registroOk", sender: nil)
            }
        })

        
    }
    

}
