//
//  LoginEmailPassViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class LoginEmailPassViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        FIRAnalytics.setScreenName("Login Usuario y contraseña", screenClass: "LoginEmailPassViewController")

        // Do any additional setup after loading the view.
    }

   
    @IBAction func doLogin(_ sender: Any) {
        FIRAnalytics.logEvent(withName: "Login Email/Pass", parameters: nil)

        
        guard let email = emailText.text, let pass = passTxt.text else{
            self.showAlert(message: "Rellena todos los campos")
            return
        }
        
        if email.isEmpty || pass.isEmpty{
            self.showAlert(message: "Rellena todos los campos")
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
            if let _ = error {
                self.showAlert(message: (error?.localizedDescription)!)
            }else{
                print(user?.email)
                self.performSegue(withIdentifier: "loginOk", sender: nil)
            }
        })
        
    }

    
    

}
