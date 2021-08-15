//
//  MoreViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
class MoreViewController: UIViewController {


    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.backgroundColor = #colorLiteral(red: 0.70618031, green: 0.2750103616, blue: 0.3301646756, alpha: 1)
        callEmail()
    }
    

    func callEmail() {
        let user = Auth.auth().currentUser?.email
        emailTextLabel.text = user!
    }

    @IBAction func logoutButton(_ sender: UIButton) {
        do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let StartNVC = storyboard.instantiateViewController(identifier: "StartNavigationController") as! UINavigationController
                    
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(StartNVC, animated: true)
            } catch let signOutError as NSError {
                print("로그아웃 도중 에러 발생 \(signOutError)")
            }
    }
}
