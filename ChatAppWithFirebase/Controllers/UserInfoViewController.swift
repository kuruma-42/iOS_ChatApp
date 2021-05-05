//
//  UserInfoViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/05/04.
//

import UIKit
import Firebase

class UserInfoViewController: UIViewController {
    
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var phonenumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateofbirthTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        profileImageButton.layer.cornerRadius = 85
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        
        registerButton.layer.cornerRadius = 12
        
        registerButton.addTarget(self, action: #selector(tappedRegisterButton), for: .touchUpInside)
        registerButton.isEnabled = false
        
        phonenumberTextField.delegate = self
        addressTextField.delegate = self
        dateofbirthTextField.delegate = self
    }
    
    @objc private func tappedRegisterButton() {
        guard let phonenumber = phonenumberTextField.text else { return }
        guard let address = addressTextField.text else { return }
        guard let dateofbirth = dateofbirthTextField.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData = [
            "phone number" : phonenumber,
            "address" : address,
            "dateofbirth" : dateofbirth
        ] as [String : Any]
        
        Firestore.firestore().collection("UserInfo").document(uid).setData(docData) { (err) in
            if let err = err {
                print("Save UserInfo Failed. \(err)")
                return
            }
        }
    }
    
    
}

extension UserInfoViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let phonenumberIsEmpty = phonenumberTextField.text?.isEmpty ?? false
        let addressIsEmpty = addressTextField.text?.isEmpty ?? false
        let dateofbirthIsEmpty = dateofbirthTextField.text?.isEmpty ?? false
        
        if(phonenumberIsEmpty || addressIsEmpty || dateofbirthIsEmpty){
            registerButton.isEnabled = true
            registerButton.backgroundColor = .rgb(red: 100, green: 100, blue: 100)

        } else {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(red: 0, green: 185, blue: 0)
        }
    }
}
