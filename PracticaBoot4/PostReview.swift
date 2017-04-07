//
//  PostReview.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase

class PostReview: UIViewController {

    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var postTxt: UITextField!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var loaderImage: UIActivityIndicatorView!
    
    var model : Posts!
    var user : FIRUser!
    var postRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FIRAnalytics.setScreenName("Detalle/Review Post", screenClass: "PostReview")

        
    }

    
    @IBAction func rateAction(_ sender: Any) {
        print("\((sender as! UISlider).value)")
    }

    @IBAction func ratePost(_ sender: Any) {
        FIRAnalytics.logEvent(withName: "Valoracion", parameters: ["puntuacion" : rateSlider.value as NSObject])

        print(rateSlider.value)
        self.valorarFB(value: rateSlider.value )
        
        
    }

    
    
    //MARK: - UI
    func setupUI() {
        
        guard let model = self.model else {return}
        self.titleTxt.text = model.title
        self.postTxt.text = model.description
        downloadImage()
        
    }
    
    func downloadImage(){
        guard let urlImage = model.urlImg else {
            self.loaderImage.isHidden = true
            return
        }
        guard let url = URL(string: urlImage) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error{
                print("\(error?.localizedDescription)")
                return
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imagePost.image = image
                self.loaderImage.isHidden = true
            }
            
        }
        task.resume()
    }

}


//FIREBASE
extension PostReview {
    
    func valorarFB(value : Float){
        postRef = FIRDatabase.database().reference().child("PostsReviews")
        let key = model.refInCloud!.key
        let valoracion = [ user.uid : ["puntos" : value]]
        let recordInFB = ["\(key)" : valoracion ]
        
        postRef.child("valoraciones").updateChildValues(recordInFB) { (error, referece) in
            if let _ = error {
                self.showAlert(message: "Error al guardar tu valoración")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
