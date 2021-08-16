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
    @IBOutlet weak var greenLabel: UILabel!
    
    @IBOutlet weak var challengeUpdateText: UILabel!
    @IBOutlet weak var contributionView: UIView!
    @IBOutlet weak var challengeButton: UIView!
    @IBOutlet weak var ringProgress: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var challengeText: UIButton!
    @IBOutlet weak var activityGraph: UILabel!
    let dataBase = Firestore.firestore()
    let month = Month()
    var dataSquare: [[Int]] = []
    var writing = [Int]()
    var index: Int = UserDefaults.standard.integer(forKey: "index")
    let dayArray = [1,5,15,30,99]
    var tlqkf: String = ""
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
        //textLabel.text = "fhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjds"
        
        ringProgressView.startColor = #colorLiteral(red: 0.00112261367, green: 0.7317003608, blue: 0.8825521469, alpha: 1)
        ringProgressView.endColor = #colorLiteral(red: 0.006783903111, green: 0.9808149934, blue: 0.8184377551, alpha: 1)
        ringProgressView.ringWidth = 8
        ringProgressView.progress = 0.7
        //contributionView.layer.cornerRadius = 10
        ringProgress.addSubview(ringProgressView)
        //challengeUpdateText.text = ""
        CircleStatus()
        contribute()
        print(dataSquare)
       // challengeUpdateText.text? = "\(self.dayArray[self.index])일 중 8일 달성!"
        activityGraph.layer.backgroundColor = #colorLiteral(red: 0.3912160629, green: 0.5305428862, blue: 0.676872947, alpha: 1)
        activityGraph.clipsToBounds = true
        activityGraph.layer.cornerRadius = 10
        activityGraph.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        //upDateIndex()
        print("d \(tlqkf)")
        
        print("Index: \(index)")
    }
    
    func upDateIndex() {
        var string = ""
        self.index = UserDefaults.standard.integer(forKey: "index")
        var dayCount: [Int] = []
        
        dataBase.collection((String(describing: Auth.auth().currentUser?.email))).order(by: "time").addSnapshotListener { QuertSnapshot, error in
            
            self.CircleStatus()
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
                            if dayCount.contains(num) == false{
                                dayCount.append(num)
                            }
                            print("\(self.dayArray[self.index])일 중 \(dayCount.count)일 달성!")
                            string = "\(self.dayArray[self.index])일 중 \(dayCount.count)일 달성!"
                            self.tlqkf = string
                            //print("좀 나와라 제발: \(String(describing: self.challengeUpdateText.text))")
                        }
                    }
                }
            }
        }
         
        
    }
    
    func CircleStatus() {
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
    
    func contribute() {
        self.index = UserDefaults.standard.integer(forKey: "index")
        dataBase.collection((String(describing: Auth.auth().currentUser?.email))).order(by: "time").addSnapshotListener { [self] QuertSnapshot, error in
            var dayCount: [Int] = []
            self.CircleStatus()
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
                            self.contributionView.addSubview(contribution)
                            contribution.centerXAnchor.constraint(equalTo: self.contributionView.centerXAnchor).isActive = true
                            contribution.centerYAnchor.constraint(equalTo: self.contributionView.centerYAnchor).isActive = true
                            //contribution.heightAnchor.constraint(equalToConstant: 80).isActive = true
                            //contribution.widthAnchor.constraint(equalToConstant: 80).isActive = true
                            //print("count\(self.dataSquare.count)")
                            let m
                                = self.month.setNumber()
                            self.challengeUpdateText.text = "\(self.dayArray[self.index])일 중 \(dayCount.count)일 달성!"
                            print(m)
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
                            self.contributionView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner)
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
    @IBAction func button(_ sender: Any) {
        index = UserDefaults.standard.integer(forKey: "index")
        print(index)
    }
}

