//
//  MoreViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
class MoreViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
