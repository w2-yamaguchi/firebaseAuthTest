//
//  MainViewController.swift
//  firebaseAuthTest
//
//  Created by Yamaguchi Wataru on 2017/05/07.
//  Copyright © 2017年 Yamaguchi Wataru. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.¥
        displayNameLabel.text = user?.displayName
        
        let profileImageKey = "profilePhoto_\(String(describing: user?.uid))"
        
        if UserDefaults.standard.object(forKey: profileImageKey) != nil {
            profileImageView.image = UIImage(data: UserDefaults.standard.data(forKey: profileImageKey)!)
        } else {
            getProfileImage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignOutTapped(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        
        do {
            try firebaseAuth?.signOut()
            self.performSegue(withIdentifier: "SignedOutSegue", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func getProfileImage() {
        let config: URLSessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        let session: URLSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let request: URLRequest =  URLRequest(url: (user?.photoURL)!)
        let myTask: URLSessionDownloadTask = session.downloadTask(with: request)
        myTask.resume()
    }

}

extension MainViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("finish download")
        
        var data: NSData!
        
        do {
            data = try NSData(contentsOf: location, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            print(error)
        }
        
        if let _data = data {
            let imageView = UIImage(data: _data as Data)!
            profileImageView.image = imageView
            
            UserDefaults.standard.set(UIImageJPEGRepresentation(imageView, 1), forKey: "profilePhoto_\(String(describing: user?.uid))")
        }
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
            print("completed download")
        } else {
            print("failed download")
        }
        
    }
    
}
