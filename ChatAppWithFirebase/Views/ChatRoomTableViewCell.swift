//
//  ChatRoomTableViewCell.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/09.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    var messageText: String? {
        didSet{
            guard let text = messageText else {return}
            let width = estimateFrameForTextView(text: text).width + 20
            
            messageTextViewWithConstraint.constant = width
            messageTextView.text = text
        }
    }
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageTextViewWithConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        backgroundColor = .clear
        userImageView.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius = 15
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func estimateFrameForTextView(text : String) -> CGRect{
      let size = CGSize(width: 200, height: 1000)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}
