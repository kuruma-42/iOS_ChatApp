//
//  User.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/16.
//

import Foundation
import Firebase

class User {
    
    let email : String
    let username : String
    let createdAt : Timestamp
    let profileImageurl : String
    
    
    init(dic : [String : Any] ) {
        self.email = dic["email"] as? String ?? ""
        self.username = dic["username"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageurl = dic["profileImageUrl"] as? String ?? ""
    }
}
