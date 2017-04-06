//
//  Posts.swift
//  Scoops
//
//  Created by Jose Javier Montes Romero on 6/4/17.
//  Copyright © 2017 COM. All rights reserved.
//

import Foundation
import Firebase

class Posts {
    
    var title: String
    var description: String
    var author: String
    var status: Bool
    var urlImg: String?
    var refInCloud: FIRDatabaseReference?
    
    init(title: String, description: String, author: String, status: Bool, urlImg: String) {
        self.title = title
        self.description = description
        self.author = author
        self.status = status
        self.urlImg = urlImg
        self.refInCloud = nil
    }
    
    init(snap: FIRDataSnapshot?){
        self.refInCloud = snap?.ref
        self.title = (snap?.value as? [String : Any])?["title"] as! String
        self.description = (snap?.value as? [String : Any])?["description"] as! String
        self.author = (snap?.value as? [String : Any])?["author"] as! String
        self.status = (snap?.value as? [String : Any])?["status"] as! Bool
        if let aUrl = (snap?.value as? [String : Any])?["urlImage"]  {
            self.urlImg = aUrl as? String
        }else{
            self.urlImg = nil
        }
        
    }


    
}
