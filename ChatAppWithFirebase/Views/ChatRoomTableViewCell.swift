//
//  ChatRoomTableViewCell.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/09.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    
    var message: Message? {
        didSet{
            if let message = message {
                messageTextView.text = message.message
                
                let width = estimateFrameForTextView(text: message.message).width + 20
                messageTextViewWithConstraint.constant = width
                
                dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
                
            }
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
    
    private func dateFormatterForDateLabel(date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
