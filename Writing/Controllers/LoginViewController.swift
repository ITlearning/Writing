//
//  LoginViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import TextFieldEffects
import NotificationBannerSwift
import SwiftOverlays
class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginTitle.textColor = #colorLiteral(red: 0.08904095739, green: 0.2666738331, blue: 0.2922615409, alpha: 1)
        subTitle.textColor = #colorLiteral(red: 0.06123912906, green: 0.2014964892, blue: 0.2014964892, alpha: 1)
        self.view.backgroundColor = #colorLiteral(red: 0.2418444157, green: 0.8603392243, blue: 0.8587271571, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.06123912906, green: 0.2014964892, blue: 0.2014964892, alpha: 1)
    }
    

    
    @IBAction func loginButton(_ sender: Any) {
        print("확인")
        let text = "로그인 중..."
        self.showWaitOverlayWithText(text)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email,password: password) { authResult, error in
                if let e = error {
                    let errorModel = ErrorModel(error: e.localizedDescription)
                    let banner = NotificationBanner(title: "뭔가가 이상해요!", subtitle: errorModel.krError, style: .danger)
                    banner.show()
                    print(errorModel.krError)
                    self.removeAllOverlays()
                } else {
                    self.removeAllOverlays()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainViewController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                }
            }
        }
    }
    
}
