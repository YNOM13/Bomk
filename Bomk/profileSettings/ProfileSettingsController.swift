//
//  ProfileSettingsController.swift
//  Bomk
//
//  Created by Yaroslav on 4/21/24.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore

class ProfileSettingsController: UIViewController{
    @IBOutlet weak var oldPasswordLabel: UITextField!
    @IBOutlet weak var newPasswordLabel: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeProfileSettings(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func oldPassword(_ sender: Any) {
    }
    @IBAction func newPassword(_ sender: Any) {
    }
    @IBAction func repeatPassword(_ sender: Any) {
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        guard let oldPassword = oldPasswordLabel.text,
              let newPassword = newPasswordLabel.text,
              let repeatPassword = repeatPasswordLabel.text else {
            showAlert(message: "будь ласка заповніть всі форми")
            return
        }
        
        guard newPassword == repeatPassword else {
            showAlert(message: "Пароль не зівпадає.")
            return
        }
        
        if let currentUser = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: oldPassword)
            currentUser.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    self.showAlert(message: "Reauthentication error: \(error.localizedDescription)")
                } else {
                    currentUser.updatePassword(to: newPassword) { error in
                        if let error = error {
                            self.showAlert(message: "Password update error: \(error.localizedDescription)")

                        } else {
                            self.showAlert(message: "Password updated successfully")
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        guard let oldPassword = oldPasswordLabel.text, !oldPassword.isEmpty,
              let newPassword = newPasswordLabel.text, !newPassword.isEmpty,
              let repeatPassword = repeatPasswordLabel.text, !repeatPassword.isEmpty else {
            return
        }
        
    }
    
}
