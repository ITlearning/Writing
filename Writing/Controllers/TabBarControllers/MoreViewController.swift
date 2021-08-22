//
//  MoreViewController.swift
//  Writing
//  더보기 뷰 컨트롤러
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase

class MoreViewController: UIViewController {
    
    //MARK: - Status Bar 색 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // 뷰 구성 버튼들
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.backgroundColor = #colorLiteral(red: 0.70618031, green: 0.2750103616, blue: 0.3301646756, alpha: 1)
        callEmail()
    }
    
    //MARK: - 이메일 불러오기
    func callEmail() {
        let user = Auth.auth().currentUser?.email
        emailTextLabel.text = user!
    }

    //MARK: - 로그아웃 버튼 클릭 시
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let StartNVC = storyboard.instantiateViewController(identifier: "StartNavigationController") as! UINavigationController
            
            // 로그아웃이 정상적으로 진행 됐을 시, 루트 뷰 컨트롤러 변경(앱 초기 상태로 전환)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(StartNVC, animated: true)
        } catch let signOutError as NSError {
            print("로그아웃 도중 에러 발생 \(signOutError)")
        }
    }
}
