//
//  LoginViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 6/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func doAnonimoLogin(_ sender: Any) {
        
        performSegue(withIdentifier: "loginOk", sender: nil)
    }
    
    @IBAction func doFacebookLogin(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
