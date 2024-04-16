//
//  ProfileController.swift
//  Bomk
//
//  Created by Yaroslav on 4/7/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import Kingfisher

class ProfileController: UIViewController{
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        fetchUserProfile()
    }
    private func fetchUserProfile() {
            guard let user = Auth.auth().currentUser else {
                print("No user is logged in")
                return
            }

            emailLabel.text = user.email
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(user.uid)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data() {
                        let name = data["name"] as? String
                        self.nameLabel.text = name
                    } else {
                        print("Document does not contain 'name'")
                    }
                } else if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                }
            }
        }
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()

        }catch{
            print(error)
        }
    }
}
