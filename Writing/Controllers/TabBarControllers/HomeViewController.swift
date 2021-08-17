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
    // UILabel
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var activityGraph: UILabel!
    @IBOutlet weak var challengeUpdateText: UILabel!
    
    // UIButton
    @IBOutlet weak var buttonLayout: UIButton!
    @IBOutlet weak var challengeText: UIButton!
    
    // UIView
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var challengeButton: UIView!
    @IBOutlet weak var ringProgress: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    let dataBase = Firestore.firestore()
    let month = Month()
    let ringProgressView = RingProgressView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
    let dayArray = [1,5,15,30,99]
    
    var lastOffsetY: CGFloat = 0
    var num: Int = 0
    var dataSquare: [[Int]] = []
    var writing = [Int]()
    var index: Int = UserDefaults.standard.integer(forKey: "index")
    
    
    //MARK: - Status Bar 색 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - 뷰가 나왔을 때
    override func viewDidAppear(_ animated: Bool) {
        contribute()
        greenLabelUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(month.setNumber())
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        appNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subLabel.textColor = #colorLiteral(red: 0.9306344697, green: 0.9306344697, blue: 0.9306344697, alpha: 1)

        scrollView.delegate = self
        

        greenLabelUpdate()
        contribute()
        print(dataSquare)
        activityGraph.layer.backgroundColor = #colorLiteral(red: 0.3912160629, green: 0.5305428862, blue: 0.676872947, alpha: 1)
        activityGraph.clipsToBounds = true
        activityGraph.layer.cornerRadius = 10
        activityGraph.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }
    
    
    //MARK: - 잔디 세팅
    func greenLabelUpdate() {
        self.dataSquare = []
        let m = month.setNumber()
        var tmp: [Int] = []
        for i in 1...m {
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
    }
    
    //MARK: - 파이어베이스 서버 땡겨오기
    func contribute() {
        self.index = UserDefaults.standard.integer(forKey: "index")
        print("index \(self.index)")
        dataBase.collection((String(describing: Auth.auth().currentUser?.email))).order(by: "time").addSnapshotListener { [self] QuertSnapshot, error in
            var dayCount: [Int] = []
            self.greenLabelUpdate()
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
                            let num = Int(date.string(from: day))!
                            //self.CircleStatus()
                            if dayCount.contains(num) == false{
                                dayCount.append(num)
                            }
                            if num <= 10 {
                                self.dataSquare[0][num-1] += 1
                            } else if num <= 20 {
                                self.dataSquare[1][num-11] += 1
                            } else if num <= 30 {
                                self.dataSquare[2][num-21] += 1
                            }
                            let contribution = LSHContributionView(frame: CGRect(x: 0, y: 0, width: 200, height: 130))
                            contribution.translatesAutoresizingMaskIntoConstraints = false
                            
                            contribution.data = self.dataSquare
                            contribution.colorScheme = "Default"
                            let m
                                = self.month.setNumber()
                            self.contributionView.addSubview(contribution)
                            self.challengeUpdateText.text = "\(self.dayArray[self.index])일 중 \(dayCount.count)일 달성!"
                            contribution.centerXAnchor.constraint(equalTo: self.contributionView.centerXAnchor).isActive = true
                            contribution.centerYAnchor.constraint(equalTo: self.contributionView.centerYAnchor).isActive = true
                            
                            // 챌린지 뷰 컨트롤러로 실시간 작성개수 넘기기
                            guard let vc = self.storyboard?.instantiateViewController(identifier: "ChallengeViewController") as? ChallengeViewController else { return }
                            vc.nowWriting = Double(dayCount.count)
                            
                            ringProgressView.startColor = #colorLiteral(red: 0.00112261367, green: 0.7317003608, blue: 0.8825521469, alpha: 1)
                            ringProgressView.endColor = #colorLiteral(red: 0.006783903111, green: 0.9808149934, blue: 0.8184377551, alpha: 1)
                            ringProgressView.ringWidth = 8
                            
                            ringProgressView.progress = Double(dayCount.count)/Double(self.dayArray[self.index])
                            
                            ringProgress.addSubview(ringProgressView)
                            
                            // 코드를 통한 오토레이아웃 설정
                            if m <= 30 {
                                contribution.leadingAnchor.constraint(equalTo: self.contributionView.leadingAnchor, constant: 10).isActive = true
                                contribution.trailingAnchor.constraint(equalTo: self.contributionView.trailingAnchor, constant: -10).isActive = true
                                contribution.topAnchor.constraint(equalTo: self.contributionView.topAnchor, constant: 10).isActive = true
                                contribution.bottomAnchor.constraint(equalTo: self.contributionView.bottomAnchor, constant: 0).isActive = true
                                contribution.heightAnchor.constraint(equalTo: self.contributionView.heightAnchor, constant: 20).isActive = true
                            } else {
                                contribution.leadingAnchor.constraint(equalTo: self.contributionView.leadingAnchor, constant: 20).isActive = true
                                contribution.trailingAnchor.constraint(equalTo: self.contributionView.trailingAnchor, constant: -20).isActive = true
                                contribution.topAnchor.constraint(equalTo: self.contributionView.topAnchor, constant: 5).isActive = true
                                contribution.bottomAnchor.constraint(equalTo: self.contributionView.bottomAnchor, constant: -20).isActive = true
                                contribution.heightAnchor.constraint(equalTo: self.contributionView.heightAnchor, constant: 0).isActive = true
                                //contribution.widthAnchor.constraint(equalTo: self.contributionView.widthAnchor, constant: 50).isActive = true
                            }
                            
                            contribution.backgroundColor = .clear
                            self.contributionView.layer.cornerRadius = 10
                            
                            // 원하는 위치 Radius 설정
                            self.contributionView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner)
                            
                        }
                    }
                }
            }
        }
    }
    
    
    // status Bar 터치시 위로 올라가게 설정
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    
    // 벨 버튼
    @IBAction func bellButton(_ sender: UIButton) {
        print("Good")
        
    }
    
}
