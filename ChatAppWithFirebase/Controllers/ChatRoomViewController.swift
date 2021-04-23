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
                        self.chatRoomTableView.reloadData()
                    case.modified, .removed :
                        print("nothing to do")
                    }
                })
            }
    }
}

extension ChatRoomViewController : ChatInputAccessoryViewDelegate{
    func tappedSendButton(text: String) {
        guard let chatroomDocId = chatroom?.documentId else { return }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()
        
        let docData = [
            "name" : name,
            "createAt": Timestamp(),
            "uid": uid,
            "message": text
        ] as [String : Any]
        
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").document()
            .setData(docData) { (err) in
                if let err = err {
                    print("Save Message Information Failed. \(err)")
                    return
            }
                print("Save Message Success.")
                
            }
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
//        cell.messageTextView.text = messages[indexPath.row]
        
        cell.message = messages[indexPath.row]
        return cell
    }
    
    
}


