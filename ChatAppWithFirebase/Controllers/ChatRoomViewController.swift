//
//  ChatRoomViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/09.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    var user: User?
    var chatroom : ChatRoom?

    private let cellId = "cellId"
    private var messages = [Message]()
    
    
    //MARK: - Make Instance
    private lazy var chatInputAccessoryView : ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
        chatRoomTableView.contentInset = .init(top: 60, left: 0, bottom: 0, right: 0)
        chatRoomTableView.scrollIndicatorInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
        //Keyboard gone whem slide down keyboard
        chatRoomTableView.keyboardDismissMode = .interactive
        chatRoomTableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        fetchMessagee()
}
    
    override var inputAccessoryView: UIView? {
        get{
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true 
    }
    
    private func fetchMessagee(){
        guard let chatroomDocId = chatroom?.documentId else { return }
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages")
            .addSnapshotListener { (snapshots, err) in
                if let err = err {
                    print("Get Message Information Failed")
                    return
                }
                
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type{
                    case .added :
                        let dic = documentChange.document.data()
                        let message = Message(dic: dic)
                        message.partneruser = self.chatroom?.partnerUser
                        self.messages.append(message)
                        self.messages.sort { (m1, m2) -> Bool in
                            let m1Date = m1.createdAt.dateValue()
                            let m2Date = m2.createdAt.dateValue()
                            return m1Date > m2Date
                        }
                        
                        self.chatRoomTableView.reloadData()
//                        self.chatRoomTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                    case.modified, .removed :
                        print("nothing to do")
                    }
                })
            }
    }
}

extension ChatRoomViewController : ChatInputAccessoryViewDelegate{
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)
    }
    
    private func addMessageToFirestore(text : String){
        guard let chatroomDocId = chatroom?.documentId else { return }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()
        let messageId = randomString(length: 20)
        
        let docData = [
            "name" : name,
            "createAt": Timestamp(),
            "uid": uid,
            "message": text
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId)
            .collection("messages").document(messageId).setData(docData) { (err) in
                if let err = err {
                    print("Save Message Information Failed. \(err)")
                    return
                }
                
                let latestMessageData = [
                    "latestMessageId": messageId
                ]
                
                Firestore.firestore().collection("chatRooms").document(chatroomDocId).updateData(latestMessageData) { (err) in
                    if let err = err{
                        print("Get Message Uid Failed \(err)")
                        return
                    }
                    
                    print("Save Message Success.")
                    
                }
                
            }

    }
    
    func randomString(length: Int) -> String {
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)

            var randomString = ""
        for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
    }
    
}
    

extension ChatRoomViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! ChatRoomTableViewCell
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
//        cell.messageTextView.text = messages[indexPath.row]
        
        cell.message = messages[indexPath.row]
        return cell
    }
    
    
}


