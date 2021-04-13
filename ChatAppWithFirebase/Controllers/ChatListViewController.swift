//
//  ChatListViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/08.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = .rgb(red: 39, green:49, blue: 69)
        self.navigationController?.navigationBar.topItem?.title = "TALK"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension ChatListViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        return cell
    }
    
    //MARK: - React When user tap cells
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view ")
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        
    }
}

class ChatListTableViewCell : UITableViewCell{
    
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
    
}
