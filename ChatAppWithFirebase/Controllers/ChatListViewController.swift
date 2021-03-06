//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/08.
//

import UIKit
import Firebase
import Nuke

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    private var chatrooms = [ChatRoom]()
    private var chatRoomListener: ListenerRegistration?
    private var user: User?{
        didSet{
            navigationItem.title = user?.username
        }
    }
    
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        confirmLoggedInUser()
        fetchChatroomsInfoFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchLoginUserInfo()
    }
    
    func fetchChatroomsInfoFromFirestore(){
        chatRoomListener?.remove()
        chatrooms.removeAll()
        chatListTableView.reloadData()
        
        chatRoomListener = Firestore.firestore().collection("chatRooms")
            .addSnapshotListener { (snapshots, err) in
                if let err = err{
                    print("Get ChatRooms Data Failed:\(err)")
                    return
                }
                
                snapshots?.documentChanges.forEach({ (documentChange) in
                    switch documentChange.type {
                    case .added:
                        self.handleAddedDocumentChage(documentChange: documentChange)
                    case .modified,.removed:
                        print("nothing to do")
                    }
                })
            }
    }
    
    private func handleAddedDocumentChage(documentChange : DocumentChange){
        let dic = documentChange.document.data()
        let chatroom = ChatRoom(dic: dic)
        chatroom.documentId = documentChange.document.documentID
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isContain = chatroom.members.contains(uid)
        
        if !isContain {
            return
        }
        chatroom.members.forEach { (memberUid) in
            if memberUid != uid {
                Firestore.firestore().collection("users").document(memberUid).getDocument { (usersnapshot, err) in
                    if let err = err {
                        print("Get Members Data Failed \(err)")
                        return
                    }
                    
                    guard let dic = usersnapshot?.data() else { return }
                    let user = User(dic: dic)
                    user.uid = documentChange.document.documentID
                    chatroom.partnerUser = user
                    
                    guard let chatroomId = chatroom.documentId else { return }
                    let latestMessageId = chatroom.latestMessageId
                    
                    if latestMessageId == "" {
                        self.chatrooms.append(chatroom)
                        self.chatListTableView.reloadData()
                        return
                    }
                    
                    Firestore.firestore().collection("chatRooms").document(chatroom.documentId ?? "").collection("messages").document(latestMessageId).getDocument { (messagesnapshot, err) in
                        
                        if let err = err {
                            print("Get Latest Information Failed. \(err)")
                            return
                        }
                        
                        guard let dic = messagesnapshot?.data() else { return }
                        let message = Message(dic: dic)
                        chatroom.latestMessage = message
                        
                        self.chatrooms.append(chatroom)
                        self.chatListTableView.reloadData()
                        
                    }
                    
                }
            }
        }
    }
    
    private func setupViews() {
        chatListTableView.tableFooterView = UIView()
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .rgb(red: 39, green:49, blue: 69)
        self.navigationController?.navigationBar.topItem?.title = "TALK"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        let rightBarButton = UIBarButtonItem(title: "New Chat", style: .plain, target: self, action: #selector(tappedNavRightBarButton))
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(tappedLogoutButton))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc private func tappedLogoutButton(){
        do{
            try
                Auth.auth().signOut()
            pushLoginViewController()
        } catch {
            print("Logout Failed. \(error)")
        }
    }
    
    private func confirmLoggedInUser(){
        if Auth.auth().currentUser?.uid == nil{
            pushLoginViewController()
        }
    }
    
    private func pushLoginViewController() {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    @objc private func tappedNavRightBarButton(){
        let storyboard = UIStoryboard.init(name: "UserList", bundle: nil)
        let userListViewController = storyboard.instantiateViewController(withIdentifier: "UserListViewController")
        let nav = UINavigationController(rootViewController: userListViewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    private func fetchLoginUserInfo(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err{
                print("Get Login User Information Failed \(err)")
            }
            
            guard let snapshot = snapshot, let dic = snapshot.data() else { return }
            
            let user = User(dic: dic)
            self.user = user
            
        }
    }
    
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ChatListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatrooms.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        
        cell.chatroom = chatrooms[indexPath.row]
        
        return cell
    }
    
    //MARK: - React When user tap cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        chatRoomViewController.user = user
        chatRoomViewController.chatroom = chatrooms[indexPath.row]
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
}

class ChatListTableViewCell : UITableViewCell{
    
    var chatroom : ChatRoom? {
        didSet{
            if let chatroom = chatroom {
                partnerLabel.text = chatroom.partnerUser?.username
                
                guard let url = URL(string: chatroom.partnerUser?.profileImageurl ?? "") else { return }
                Nuke.loadImage(with: url, into: userImageView)
                
                dateLabel.text = dateFormatterForDateLabel(date: chatroom.latestMessage?.createdAt.dateValue() ?? Date())
                latestMessageLabel.text = chatroom.latestMessage?.message
            }
            partnerLabel.text = chatroom?.partnerUser?.username
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 30
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func dateFormatterForDateLabel(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
