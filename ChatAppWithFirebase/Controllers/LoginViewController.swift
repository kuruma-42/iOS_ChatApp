//
//  LoginViewController.swift
//  ChatAppWithFirebase
//
//  Created by Yong Jun Cha on 2021/04/26.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccountButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(tappedLoginButton), for: .touchUpInside)
    }
    
    @objc private func tappedDontHaveAccountButton(){
        
    }
    
    @objc private func tappedLoginButton(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print("Login Failed \(err)")
                return
            }
            
            print("Login Success")
            
            let nav = self.presentingViewController as! UINavigationController
            let chatListViewController = nav.viewControllers[nav.viewControllers.count - 1] as? ChatListViewController
            chatListViewController?.fetchChatroomsInfoFromFirestore()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
