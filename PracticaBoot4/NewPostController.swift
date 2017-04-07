//
//  NewPostController.swift
//  PracticaBoot4
//
//  Created by Juan Antonio Martin Noguera on 23/03/2017.
//  Copyright © 2017 COM. All rights reserved.
//

import UIKit
import Firebase
typealias completionUploadMedia = (_: String?) -> Void

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titlePostTxt: UITextField!
    @IBOutlet weak var textPostTxt: UITextField!
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    // Firebase properties
    var postRef : FIRDatabaseReference!
    var storageRef : FIRStorageReference!
    var user : FIRUser!
    
    
    
    var isReadyToPublish: Bool = false
    var imageCaptured: UIImage! {
        didSet {
            imagePost.image = imageCaptured
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = true
        self.hideKeyboardWhenTappedAround()

        setupFirebaseReferences()
        
    }


    
    @IBAction func takePhoto(_ sender: Any) {
        self.present(pushAlertCameraLibrary(), animated: true, completion: nil)
    }
    @IBAction func publishAction(_ sender: Any) {
        isReadyToPublish = (sender as! UISwitch).isOn
    }

    @IBAction func savePostInCloud(_ sender: Any) {
        FIRAnalytics.logEvent(withName: "Crear post", parameters: nil)

        // preparado para implementar codigo que persita en el cloud
        if let image = imagePost.image {
            newPost(title: titlePostTxt.text!, description: textPostTxt.text!, status: isReadyToPublish, author: user.email!, imgData: UIImageJPEGRepresentation(imagePost.image!, 0.5))
        }else{
            newPost(title: titlePostTxt.text!, description: textPostTxt.text!, status: isReadyToPublish, author: user.email!)

        }
    }
    
    

    // MARK: - funciones para la camara
    internal func pushAlertCameraLibrary() -> UIAlertController {
        let actionSheet = UIAlertController(title: NSLocalizedString("Selecciona la fuente de la imagen", comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .actionSheet)
        
        let libraryBtn = UIAlertAction(title: NSLocalizedString("Ussar la libreria", comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.photoLibrary)
            
        }
        let cameraBtn = UIAlertAction(title: NSLocalizedString("Usar la camara", comment: ""), style: .default) { (action) in
            self.takePictureFromCameraOrLibrary(.camera)
            
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        actionSheet.addAction(libraryBtn)
        actionSheet.addAction(cameraBtn)
        actionSheet.addAction(cancel)
        
        return actionSheet
    }
    
    internal func takePictureFromCameraOrLibrary(_ source: UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        switch source {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                picker.sourceType = UIImagePickerControllerSourceType.camera
            } else {
                return
            }
        case .photoLibrary:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        case .savedPhotosAlbum:
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(picker, animated: true, completion: nil)
    }

}

// MARK: - Delegado del imagepicker
extension NewPostController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageCaptured = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.dismiss(animated: false, completion: {
        })
    }
    
}


// MARK: - Metodos para Firebase
extension NewPostController {
    
    func setupFirebaseReferences(){
        FIRAnalytics.setScreenName("Nueva Noticia", screenClass: "NewPostController")

        postRef = FIRDatabase.database().reference().child("Posts")
        storageRef = FIRStorage.storage().reference(forURL: "gs://scoops-b41b8.appspot.com").child("media")
        
    }
    
    
    func newPost(title: String, description: String, status: Bool, author: String, imgData: Data! = nil){
        let key = postRef.child("articulos").childByAutoId().key
        
        
        let post : [String : Any] = ["title" : title, "description" : description, "status": status, "author" : author]
        let recordInFB = ["\(key)" : post]
        
        self.loader.startAnimating()
        self.loader.isHidden = false
        self.view.isUserInteractionEnabled = false
        postRef.child("articulos").updateChildValues(recordInFB, withCompletionBlock: { (error, reference) in
            if let _ = error {
                self.showAlert(message: "Error al grabar el post, inténtalo de nuevo.")
                return
            }
            // Si tenemos imagen la subimos
            if let _ = imgData{
                self.uploadMedia(data: imgData, name: key, completionHandler: { (urlDownload) in
                    guard let urlImage = urlDownload else {return}
                    let urlToPost = ["urlImage" : urlImage]
                    self.postRef.child("articulos").child(key).updateChildValues(urlToPost)
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    self.view.isUserInteractionEnabled = true

                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                self.loader.stopAnimating()
                self.loader.isHidden = true
                self.view.isUserInteractionEnabled = true
                self.navigationController?.popViewController(animated: true)
                
            }

        })
        
        
    }
    
    
    func uploadMedia(data : Data, name: String, completionHandler : @escaping completionUploadMedia) {
    
        let imgRef = storageRef.child("\(name).jpg")
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploadTask = imgRef.put(data, metadata: metadata) { metadata, error in
            if (error != nil) {
                completionHandler(nil)
            } else {
                let downloadURL = metadata!.downloadURL()
                completionHandler(downloadURL?.absoluteString)
            }
        }
        
        
    }
    
    
    
}










