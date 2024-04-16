import UIKit
import FirebaseCore
import FirebaseAuth

@main class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                self.showModalAuth()
            }
        }
        
        return true
    }
    
    func showModalAuth() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newvc = storyboard.instantiateViewController(withIdentifier: "registerUser") as! RegistrationController
        newvc.modalPresentationStyle = .fullScreen
        sceneDelegate.window?.rootViewController?.present(newvc, animated: true)
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
       
    }
}
