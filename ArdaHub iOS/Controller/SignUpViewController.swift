//
//  SignUpViewController.swift
//  ArdaHub iOS
//
//  Created by Arda Gürpınar on 27.12.2021.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlert(messageToUser: String) {
        let alert = UIAlertController(title: "Error", message: messageToUser, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        
        
        let user = UserInfo(firstName: self.firstNameText.text, lastName: self.lastNameText.text, email: self.emailText.text?.lowercased(), password: self.passwordText.text)
        
        
        if let email = user.email, let password = user.password {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    if e._code == 17007 {
                        self.showAlert(messageToUser: "This email address is already in use.")
                        print("This email address is already in use.")
                    } else {
                        self.showAlert(messageToUser: "Invalid email address or password.")
                        print("Invalid email address or password")
                    }
                    
                } else {
                    self.headerLabel.text = "New account successfully created!"
                    
                    if let fName = user.firstName, let lName = user.lastName{
                        user.storeUser(email: email, fName: fName, lName: lName)
                        
                        // Clearing text fields
                        
                        self.firstNameText.text = ""
                        self.lastNameText.text = ""
                        self.emailText.text = ""
                        self.passwordText.text = ""
                    }
                }
            }
        }
    }
}

