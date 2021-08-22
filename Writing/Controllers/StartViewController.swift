//
//  StartViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/08.
//

import UIKit
import Firebase
class StartViewController: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var subText: UILabel!
    @IBOutlet weak var loginText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        // 사실 슈퍼를 단 코드는 별다른 기능이 없다.
        // 하지만 오버라이드를 한 코드에 super를 호출하는 습관을 들이는게 좋다고 한다.
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    // 해당 화면을 벗어날 때에는 Navigation Bar가 보이게 설정한다.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainText.textColor = .white
        subText.textColor = .white
        loginText.textColor = .white
        back()
        settingButton()
        
        let backButtonItem = UIBarButtonItem(title: "돌아가기", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
        
    }
    //MARK: - 그라데이션 배경화면 설정

    func back() {
        background.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        /*
        let pastelView = PastelView(frame: background.bounds)
        
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        pastelView.animationDuration = 3.5
        
        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        pastelView.startAnimation()
        background.insertSubview(pastelView, at: 0)
        //self.view.insertSubview(pastelView, at: 0)
         */
    }
    
    func settingButton() {
        // 회원가입 버튼
        signUp.layer.cornerRadius = 10
        signUp.layer.shadowColor = UIColor.black.cgColor
        signUp.layer.masksToBounds = false
        signUp.layer.shadowOffset = CGSize(width: 0, height: 3)
        signUp.layer.shadowRadius = 3
        signUp.layer.shadowOpacity = 0.3
        
        // 로그인 버튼
        signIn.layer.cornerRadius = 10
        signIn.layer.shadowColor = UIColor.black.cgColor
        signIn.layer.masksToBounds = false
        signIn.layer.shadowOffset = CGSize(width: 0, height: 3)
        signIn.layer.shadowRadius = 3
        signIn.layer.shadowOpacity = 0.3
        
    }

    @IBAction func signUpButton(_ sender: Any) {
        print("Hello")
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
    }
    
    // 상태바 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


