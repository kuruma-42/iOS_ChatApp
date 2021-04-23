//
//  Message.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/23.
//

import Foundation
import Firebase

class Message {
    
    let name : String
    let message : String
    let uid : String
    let createdAt : Timestamp
    
    var partneruser: User?
    
    init(dic : [String : Any]){
        self.name = dic["name"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
