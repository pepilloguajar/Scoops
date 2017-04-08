//
//  detailPostViewController.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 8/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class detailPostViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var nVisualizaciones: UITextField!
    @IBOutlet weak var nValoraciones: UITextField!
    @IBOutlet weak var nMedia: UITextField!
    
    var model : Posts!
    
    var postRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pullInfoFB()
        syncViewModel()
    }
    
    func syncViewModel() {
        self.titleText.text = self.model.title
        self.descriptionText.text = self.model.description
        self.nVisualizaciones.text = "0"
    }

    
}


//MARK: - Firebase
extension detailPostViewController {
    
    func pullInfoFB(){
    
        postRef = FIRDatabase.database().reference().child("PostsReviews")
        var val : [Float]  = []
        var numVal : Int = 0
        postRef.observe(.value, with: { (snap) in
            if let postValue = ((snap.value as! [String : Any])["valoraciones"]! as! [String : Any])[(self.model.refInCloud?.key)!] {
                
                
                for value in postValue as! [String : Any]{
                    val.append((value.value as! [String : Float])["puntos"]!)
                    numVal = numVal + 1
                }
                
                self.nValoraciones.text = "\(numVal)"
                if numVal == 0 {
                    self.nMedia.text = "0"
                }else{
                    self.nMedia.text = "\(self.media(val))"
                }
            }else {
                self.nMedia.text = "0"
                self.nValoraciones.text = "\(numVal)"

            }
            
            
        })
        
    }
    
    func media(_ val : [Float]) -> Float{
        var sum = val.reduce(0, +)
        return sum / Float(integerLiteral: Int64(val.count))
    }
    
}





