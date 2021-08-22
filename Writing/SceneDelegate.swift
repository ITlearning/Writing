//
//  SceneDelegate.swift
//  Writing
//
//  Created by IT learning on 2021/08/08.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var isLogined: Bool = false
    
    
    // 가장 중요한 기능이다. scene이 앱에 추가될 때 호출된다.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // 로그인을 유무에 따라 rootController를 설정해주는 코드.
        if Auth.auth().currentUser != nil {
            // 뷰 컨트롤러 선택
            let mainTBC = storyboard.instantiateViewController(identifier: "MainViewController")
            // rootViewController 설정
            window?.rootViewController = mainTBC
        } else {
            let startNVC = storyboard.instantiateViewController(identifier: "StartNavigationController")
            window?.rootViewController = startNVC
        }
    }
    
    // scene의 연결이 해제될 때 호출된다. 다시 연결될 수도 있다.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    // app switcher에서 선택되는 등 scene과 상호작용이 시작될 때 호출된다.
    // app switcher란 홈 버튼을 두번 누르거나 아이폰 화면의 하단에서 위로 스와이프 했을 때 현재 실행 중인 앱들이 보이는 화면을 말한다.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    
    // 사용자가 scene과의 상호작용을 중지할 때 호출된다. (다른 화면으로의 전환이 예 이다.)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    
    // scene이 포그라운드로 진입할 때 호출된다.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    // scene이 백그라운드로 진입할 때 호출된다.
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    // 루트 뷰 컨트롤러를 변경할 때 사용하는 메서드
    func changeRootViewController (_ vc: UIViewController, animated: Bool) {
        // guard let으로 윈도우를 옵셔널 바인딩한 상황
        guard let window = self.window else { return }
        
        // 아까 위에서 설정한 window를 기준으로 RootViewController를 재설정하는 코드
        window.rootViewController = vc
        
        // 뷰가 변경될 때 이동하는 애니메이션과 시간등을 정의
        UIView.transition(with: window, duration: 0.4, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}

