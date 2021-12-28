//
//  FinalViewController.swift
//  ArdaHub iOS
//
//  Created by Arda Gürpınar on 27.12.2021.
//

import UIKit
import Firebase

class FinalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var posts : [Posts] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view.
        getPost()
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
        if let currentUserMail = Auth.auth().currentUser?.email, let postBody = postTextField.text {
            print(currentUserMail)
            storePost(email: currentUserMail, post: postBody)
            //getPost()
            postTextField.text = ""
        }
        
    }
    
    func storePost(email: String, post: String) {
        
        db.collection("posts").addDocument(data:
            ["email": email,
             "post": post,
             "date": Date().timeIntervalSince1970]) { error in
            if let e = error {
                print("Error writing document: \(e)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    
    func getPost() {
        
        db.collection("posts").order(by: "date").addSnapshotListener { documentName, error in
            
            self.posts = []
            
            if let e = error {
                print("Error reading document: \(e)")
            } else {
                if let documents = documentName?.documents {
                    for doc in documents {
                        print(doc.data())
                        self.posts.append(Posts(sender: doc.data()["email"] as! String, post: doc.data()["post"] as! String))
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    
}

extension FinalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell {
            //cell.textLabel?.text = posts[indexPath.row].post + "  -" + posts[indexPath.row].sender
            cell.postLabel.text = posts[indexPath.row].post
            cell.nameLabel.text = posts[indexPath.row].sender
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
}

