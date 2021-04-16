//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/08.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    private var users = [User]()
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .rgb(red: 39, green:49, blue: 69)
        self.navigationController?.navigationBar.topItem?.title = "TALK"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
        if Auth.auth().currentUser?.uid == nil{
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController")
            as! SignUpViewController
            signUpViewController.modalPresentationStyle = .fullScreen
            self.present(signUpViewController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserInfoFromFirestore()
    }
    
    private func fetchUserInfoFromFirestore(){
        Firestore.firestore().collection("users").getDocuments { (snapshots, err) in
            if let err = err {
                print("Get User Data Failed",err)
                return
            }
            
            snapshots?.documents.forEach({ (snapshot) in
                //Mark - dic : data of users
                let dic = snapshot.data()
                let user = User.init(dic: dic)
                
                self.users.append(user)
                self.chatListTableView.reloadData()
                
                self.users.forEach { (user) in
                    print(":",user.username)
                }
            })
        }
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ChatListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatListTableViewCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    //MARK: - React When user tap cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
}

class ChatListTableViewCell : UITableViewCell{
    
    var user : User? {
        didSet {
            if let user = user{
                partnerLabel.text = user.username
                //            userImageView.image = user?.profileImageurl
                dateLabel.text = dateFormatterForDateLabel(date: user.createdAt.dateValue())
                latestMessageLabel.text = user.email
            }
            
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var latestMessageLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = 35
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
