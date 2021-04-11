//
//  ChatRoomViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/09.
//

import UIKit
class ChatRoomViewController: UIViewController {
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.backgroundColor = .rgb(red: 118, green: 140, blue: 180)
}
    
}
    

extension ChatRoomViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath)
        return cell
    }
    
    
}


