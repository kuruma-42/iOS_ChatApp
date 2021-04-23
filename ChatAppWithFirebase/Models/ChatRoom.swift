//
//  ChatRoom.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/20.
//

import Foundation
import Firebase

class ChatRoom {
    let latestMessageId : String
    let members: [String]
    let createdAt: Timestamp
    
    var documentId : String?
    var partnerUser: User?
    
    init(dic : [String : Any]) {
        self.latestMessageId = dic["latestMessageId"] as? String ?? ""
        self.members = dic["members"] as? [String] ?? [String]()
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}


