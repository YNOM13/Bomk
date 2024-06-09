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
import RealmSwift

class User: Object {
  @objc dynamic var uid: String = ""
  @objc dynamic var profileImage: Data?

  override static func primaryKey() -> String? {
    return "uid"
  }
}

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleBomk(with: navigationItem)
        loadProfileImageFromLocal()
      }

      override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserProfile()
      }
    
    @IBAction func openSettingsAction(_ sender: Any) {
        if let myVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier:"profileSettings") as? ProfileSettingsController {
            myVC.modalPresentationStyle = .fullScreen
            present (myVC, animated: true)
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
          accountImage.image = pickedImage
          saveImageToLocalDatabase(image: pickedImage)
        }

        dismiss(animated: true, completion: nil)
      }

      func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
      }
    
    private func saveImageToLocalDatabase(image: UIImage) {
       do {
         let realm = try Realm()
         try realm.write {
           if let user = Auth.auth().currentUser {
             let imageData = image.jpegData(compressionQuality: 0.5)

             if let currentUser = realm.objects(User.self).filter("uid == %@", user.uid).first {
               currentUser.profileImage = imageData
             } else {
               let newUser = User()
               newUser.uid = user.uid
               newUser.profileImage = imageData
               realm.add(newUser)
             }
           }
         }
       } catch {
         print("Error saving image to local database: \(error.localizedDescription)")
       }
     }

    private func loadProfileImageFromLocal() {
        do {
          let realm = try Realm()
          if let user = Auth.auth().currentUser,
             let currentUser = realm.objects(User.self).filter("uid == %@", user.uid).first,
             let imageData = currentUser.profileImage {
            accountImage.image = UIImage(data: imageData)
          }
        } catch {
          print("Error loading image from local database: \(error.localizedDescription)")
        }
      }

    
    @IBAction func changeImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary
           present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()

        }catch{
            print(error)
        }
    }
}
