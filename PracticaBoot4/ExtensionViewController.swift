//
//  ExtensionViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 7/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit

class ExtensionViewController: UIViewController {


}


// Extensión para cerrar el teclado al hacer tap y un alert genérico
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(message : String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cerrar", style: .cancel, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
