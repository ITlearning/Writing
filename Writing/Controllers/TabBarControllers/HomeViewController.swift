//
//  HomeViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import MKRingProgressView
import Firebase
import FirebaseFirestore
import LSHContributionView
class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var buttonLayout: UIButton!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var challengeButton: UIView!
    @IBOutlet weak var ringProgress: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var challengeText: UIButton!
    let dataBase = Firestore.firestore()
    let month = Month()
    var dataSquare: [[Int]] = []
    var writing = [Int](repeating: 0, count: 31)
    
    var lastOffsetY: CGFloat = 0
    let ringProgressView = RingProgressView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(month.setNumber())
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        appNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subLabel.textColor = #colorLiteral(red: 0.9306344697, green: 0.9306344697, blue: 0.9306344697, alpha: 1)
        //buttonLayout.imageView
        scrollView.delegate = self
        textLabel.text = "fhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjds"
        
        ringProgressView.startColor = #colorLiteral(red: 0.00112261367, green: 0.7317003608, blue: 0.8825521469, alpha: 1)
        ringProgressView.endColor = #colorLiteral(red: 0.006783903111, green: 0.9808149934, blue: 0.8184377551, alpha: 1)
        ringProgressView.ringWidth = 8
        ringProgressView.progress = 0.7
        
        ringProgress.addSubview(ringProgressView)
        CircleStatus()
        contribute()
        
    }
    
    
    
    func CircleStatus() {
        let contribution = LSHContributionView(frame: CGRect(x:20 , y: 0, width: 283, height: 150))
        let m = month.setNumber()
        var tmp: [Int] = []
        for i in 1...31 {
            if i % 10 != 0 {
                tmp.append(0)
            } else {
                dataSquare.append(tmp)
                tmp = []
            }
        }
        if !tmp.isEmpty {
            dataSquare.append(tmp)
        }
        
        
        contribution.data = dataSquare
        contribution.colorScheme = "Default"
        contributionView.addSubview(contribution)
        contribution.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
    }
    
    func contribute() {
        var tmp = [Int](repeating: 0, count: 31)
        dataBase.collection((String(describing: Auth.auth().currentUser?.email))).order(by: "time").addSnapshotListener { QuertSnapshot, error in
            if let e = error {
                print("문제가 발생 했읍니다.\(e)")
            } else {
                if let snapshotDocuments = QuertSnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let serverDay = data["time"] as? Double {
                            let date: DateFormatter = {
                                let df = DateFormatter()
                                df.locale = Locale(identifier: "ko_KR")
                                df.timeZone = TimeZone(abbreviation: "KST")
                                df.dateFormat = "dd"
                                return df
                            }()
                            let today = Int(serverDay)
                            let timeInterval = TimeInterval(today)
                            let day = Date(timeIntervalSince1970: timeInterval)
                            print(Int(date.string(from: day))!-1)
                            tmp[Int(date.string(from: day))!-1] += 1
                        }
                    }
                }
            }
        }
    }
    
    // 하... 계속 배열의 카운팅이 안된다. 아니 되긴 하는데, 이게 메서드 밖으로 나가면 그냥 정보가 다 사라진다.
    // 개빡돈다........하...
    // 일단 여기까지 하자.
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    @IBAction func bellButton(_ sender: UIButton) {
        print("Good")
        
    }
}

