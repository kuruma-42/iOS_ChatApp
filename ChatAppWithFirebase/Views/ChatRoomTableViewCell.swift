//
//  ChatRoomTableViewCell.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/09.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius = 15
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
}
