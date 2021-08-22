//
//  SignUpViewController.swift
//  Writing
//  회원가입 뷰 컨트롤러
//  Created by IT learning on 2021/08/08.
//

import UIKit
import TextFieldEffects
import Firebase
import NotificationBannerSwift
import SwiftOverlays

class SignUpViewController: UIViewController {
    // Label
    @IBOutlet weak var signUpText: UILabel!
    @IBOutlet weak var subText: UILabel!
    
    
    // TextField
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.690415506, green: 0.5182294781, blue: 0.9437880516, alpha: 1)
        signUpText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.tintColor = .white
        
    }
    
    //MARK: - 회원가입 버튼 클릭 시
    @IBAction func signUpButton(_ sender: Any) {
        let text = "회원가입 중..."
        self.showWaitOverlayWithText(text)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    let errorModel = ErrorModel(error: e.localizedDescription)
                    let banner = NotificationBanner(title: "뭔가가 이상해요!", subtitle: errorModel.krError, style: .danger)
                    banner.show()
                    print(e.localizedDescription)
                    self.removeAllOverlays()
                } else {
                    self.removeAllOverlays()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    // 회원가입을 마쳤을 경우, 루트 뷰 컨트롤러를 홈 뷰 컨트롤러로 이동
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainViewController")
                    let back = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
                        
                    back?.changeRootViewController(mainTabBarController, animated: true)
                }
            }
        }
    }
    
}
