//
//  LoginViewController.swift
//  Writing
//  로그인 뷰 컨트롤러
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import TextFieldEffects
import NotificationBannerSwift
import SwiftOverlays

class LoginViewController: UIViewController {
    
    // Label
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
        
    // TextField
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
    

    //MARK: - 로그인 버튼 클릭 시
    @IBAction func loginButton(_ sender: Any) {
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
                    
                    // 로그인을 마쳤을 경우, 루트 뷰 컨트롤러를 홈 뷰 컨트롤러로 이동
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainViewController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                }
            }
        }
    }
    
}
