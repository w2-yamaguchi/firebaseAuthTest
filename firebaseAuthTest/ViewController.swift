//
//  ViewController.swift
//  firebaseAuthTest
//
//  Created by Wataru Yamaguchi on 2019/02/15.
//

import UIKit
import FirebaseAuth
import FacebookLogin

class ViewController: UIViewController, LoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("Facebook: User cancelled login.")
        case .success(_, _, let accessToken):
            print("Facebook: User is logged in!")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            firebaseSignIn(credential: credential)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        firebaseSignOut()
    }
    
    func firebaseSignIn(credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            print("Firebase: User is signed in!")
        }
    }
    
    func firebaseSignOut() {
        do {
            try Auth.auth().signOut()
            print("Firebase: User is signed out.")
        } catch let error as NSError {
            print ("Firebase: Error signing out: %@", error)
        }
    }

}

