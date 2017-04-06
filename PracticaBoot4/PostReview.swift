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
    
    var postRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    
    @IBAction func rateAction(_ sender: Any) {
        print("\((sender as! UISlider).value)")
    }

    @IBAction func ratePost(_ sender: Any) {
    }

    
    
    //MARK: - UI
    func setupUI() {
        
        guard let model = self.model else {return}
        self.titleTxt.text = model.title
        self.postTxt.text = model.description
        downloadImage()
        
    }
    
    func downloadImage(){
        guard let urlImage = model.urlImg else {return}
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
