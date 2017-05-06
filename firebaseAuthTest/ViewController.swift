//
//  ViewController.swift
//  firebaseAuthTest
//
//  Created by Yamaguchi Wataru on 2017/05/07.
//  Copyright © 2017年 Yamaguchi Wataru. All rights reserved.
//

import UIKit
import Firebase
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn([.publicProfile, .email], viewController: self, completion: {
            result in
            switch result {
            case let .success( permission, declinePemisson, token):
                print("token:\(token),\(permission),\(declinePemisson)")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                self.signIn(credential: credential)
            case let .failed(error):
                print("error:\(error)")
            case .cancelled:
                print("cancelled")
            }
            
        })
    }
    
    func signIn(credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("error:\(error)")
                return
            } else {
                self.performSegue(withIdentifier: "SignedInSegue", sender: nil)
            }
            return
        }
    }

}

