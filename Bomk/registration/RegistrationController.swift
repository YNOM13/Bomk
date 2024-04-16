//
//  RegistrationController.swift
//  Bomk
//
//  Created by Yaroslav on 3/31/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import Firebase

class RegistrationController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var doYouHaveAnAccountLabel: UILabel!
    @IBOutlet weak var LogInButton: UIButton!
    
    var signUp: Bool = true{
        willSet{
            if newValue{
                descriptionLabel.text = "Будь ласка, введіть свою інформацію, щоб створити обліковий запис"
                nameField.isHidden = false
                registerButton.setTitle("продовжити", for: .normal)
                labelName.isHidden = false
                doYouHaveAnAccountLabel.text = "Вже є акаунт?"
                LogInButton.setTitle("Увійти", for: .normal)
            }else{
                descriptionLabel.text = "Будь ласка, введіть свою інформацію, щоб увійти в обліковий запис"
                nameField.isHidden = true
                labelName.isHidden = true
                registerButton.setTitle("увійти", for: .normal)
                doYouHaveAnAccountLabel.text = "Немає акаунта?"
                LogInButton.setTitle("Зареєструйся", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        registerUser()
    }
    @IBAction func logInAction(_ sender: Any) {
        signUp = !signUp
    }
    
//    func registerUser() {
//        let name = nameField.text!
//        let email = emailField.text!
//        let password = passwordField.text!
//        
//        if(signUp){
//            if(!name.isEmpty && !password.isEmpty && !email.isEmpty){
//                Auth.auth().createUser(withEmail: email, password: password){(result,error) in
//                    if error == nil {
//                        if let result = result{
//                            print(result.user.uid)
//                            let ref = Database.database().reference().child("users")
//                            ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
//                            self.dismiss(animated: true, completion: nil)
//                        }
//                    }
//                }
//            }else{
//                showAlert()
//            }
//        }else{
//            if(!password.isEmpty && !email.isEmpty){
//                Auth.auth().signIn(withEmail: email, password: password){(result,error) in
//                    if(error == nil){
//                        self.dismiss(animated: true, completion: nil)
//                    }
//                }
//            }else{
//                showAlert()
//            }
//        }
//    }
    
    func registerUser() {
            guard let name = nameField.text, let email = emailField.text, let password = passwordField.text,
                   !email.isEmpty, !password.isEmpty else {
                showAlert(message: "Всі поля повинні бути заповнені")
                return
            }
            
            if signUp {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        self.showAlert(message: "Помилка реєстрації: \(error.localizedDescription)")
                    } else if let result = result {
                        let db = Firestore.firestore()
                        db.collection("users").document(result.user.uid).setData([
                            "name": name,
                            "email": email
                        ]) { err in
                            if let err = err {
                                self.showAlert(message: "Помилка збереження даних: \(err.localizedDescription)")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            } else {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        self.showAlert(message: "Помилка входу: \(error.localizedDescription)")
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        
        func showAlert(message: String) {
            let alert = UIAlertController(title: "Помилка", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    
    func showAlert(){
        let alert = UIAlertController(title: "Помилка ☹️", message: "Введіть дані коректно", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    

}

extension RegistrationController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = nameField.text!
        let email = emailField.text!
        let password = passwordField.text!
        
        if(signUp){
            if(!name.isEmpty && !password.isEmpty && !email.isEmpty){
                Auth.auth().createUser(withEmail: email, password: password){(result,error) in
                    if error == nil {
                        if let result = result{
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name, "email": email])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }else{
                showAlert()
            }
        }else{
            if(!password.isEmpty && !email.isEmpty){
                Auth.auth().signIn(withEmail: email, password: password){(result,error) in
                    if(error == nil){
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                }
            }else{
                showAlert()
            }
        }
        
        return true
    }
}
