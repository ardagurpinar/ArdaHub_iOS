//
//  ViewController.swift
//  ArdaHub iOS
//
//  Created by Arda Gürpınar on 27.12.2021.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        emailText.text = "".lowercased()
        passwordText.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Invalid email address or password.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
     
        let user = UserInfo(firstName: "", lastName: "", email: emailText.text?.lowercased(), password: passwordText.text)
        
        if let email = user.email, let password = user.password {
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                    print("Invalid email address or password")
                    self!.showAlert()
                } else {
                    self?.performSegue(withIdentifier: "LogInToFinal", sender: self)
                    
                }
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let user = UserInfo(firstName: "", lastName: "", email: emailText.text?.lowercased(), password: passwordText.text)
        
        if let email = user.email, let vc = segue.destination as? FinalViewController {
            //self.isValid = true
            user.getUser(email: email) { fullName in
                print("This is using completion handler: \(fullName)")
                vc.title = fullName as? String
            }
        }
    }
  
    
}
