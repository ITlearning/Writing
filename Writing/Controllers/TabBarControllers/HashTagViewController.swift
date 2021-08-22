//
//  HashTagViewController.swift
//  Writing
//  해시태그 뷰 컨트롤러
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import FirebaseFirestore
import NotificationBannerSwift
import Kingfisher

class HashTagViewController: UIViewController {

    //MARK: - Status Bar 색 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // 라벨과 테이블 뷰
    @IBOutlet weak var viewMainName: UILabel!
    @IBOutlet weak var viewSubName: UILabel!
    @IBOutlet weak var hashTagTableView: UITableView!
    @IBOutlet weak var nothingText: UILabel!
    
    // 버튼
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var boringButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    
    // 기본 변수들
    var writing: [Writing] = []
    var btnArray = [UIButton]()
    let dataBase = Firestore.firestore()
    var emotionStatus: String = "선택안됨"
    let storage = Storage.storage()
    
    //MARK: - 화면이 보일 때
    override func viewDidAppear(_ animated: Bool) {
        loadWriting()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagTableView.delegate = self
        hashTagTableView.dataSource = self
        // 테이블 뷰 셀 나누는 칸 없애기
        hashTagTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        hashTagTableView.rowHeight = UITableView.automaticDimension
        hashTagTableView.estimatedRowHeight = 360
        hashTagTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        
        viewMainName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewSubName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // 버튼 배열에 버튼들 추가
        btnArray.append(happyButton)
        btnArray.append(sadButton)
        btnArray.append(boringButton)
        btnArray.append(noneButton)
        buttonSetting()
        
    }
    
    //MARK: - 일기 불러오기
    func loadWriting() {
        originalUpdate()
    }
    
    //MARK: - 쓰레기 버튼 클릭시
    @IBAction func buttonClicked(_ sender: UIButton) {
        //print(sender.tag)
        
        let alert = UIAlertController(title: "일기삭제", message: "선택한 일기를 삭제할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel,handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            //(self.writing[sender.tag].time)
            
            // 사진 먼저 삭제
            if let writingSender = Auth.auth().currentUser?.email {
                self.dataBase.collection(writingSender).document(self.writing[sender.tag].documentID).delete() { err in
                    if let err = err {
                        let banner = NotificationBanner(title: "에러발생", subtitle: "\(err)!", style: .danger)
                        banner.show()
                    } else {
                        print("삭제 완료")
                       
                    }
                }
                
                // 뒤에 일기 삭제
                self.writing[sender.tag].deleteID.delete { error in
                    if let error = error {
                        print("에러발생 \(error)")
                    } else {
                        let banner = NotificationBanner(title: "삭제완료", subtitle: "일기를 성공적으로 삭제했어요!", style: .success)
                        banner.show()
                    }
                }
                
                self.writing.remove(at: sender.tag)

                if self.emotionStatus == "선택안됨" {
                    self.originalUpdate()
                } else {
                    self.update("emotion", emotionType: self.emotionStatus)
                    
                }
                
                if self.writing.count == 0 {
                    self.nothingText.text = "아무것도 작성하지 않았어요! 당신의 이야기를 적어주세요 😊"
                    self.nothingText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.nothingText.numberOfLines = 0
                } else {
                    self.nothingText.text = ""
                }
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - 각 감정버튼 클릭 시
    @IBAction func sortButton(_ sender: UIButton) {
        for btn in btnArray {
         guard let button = sender as? UIButton else { return }
         if btn == button  {
             if !button.isSelected {
                
                button.isSelected = true
                button.tintColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                emotionStatus = (button.titleLabel?.text)!
                update("emotion", emotionType: emotionStatus)
             } else {
                button.isSelected = false
                button.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                emotionStatus = "선택안됨"
                originalUpdate()
             }
         } else {
            
            btn.isSelected = false
            btn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            btn.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
         }
     }
}
    
    //MARK: - 버튼 색 변경
    func buttonSetting() {
        happyButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        happyButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        happyButton.layer.cornerRadius = 3
        
        sadButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        sadButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        sadButton.layer.cornerRadius = 3
        
        boringButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        boringButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        boringButton.layer.cornerRadius = 3
        
        noneButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        noneButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        noneButton.layer.cornerRadius = 3
    }

    
    //MARK: - 테이블 뷰 업데이트 목록들
    func originalUpdate() {
        if let writingSender = Auth.auth().currentUser?.email {
            
            dataBase.collection(writingSender)
                .order(by: "time")
                .addSnapshotListener { QuertSnapshot, error in
                    self.writing = []
                    var dayCount: [Int] = []
                    if let e = error {
                        print("문제가 발생했습니다. \(e)")
                    } else {
                        if let snapshotDocuments = QuertSnapshot?.documents {
                            var cnt = 0
                            for doc in snapshotDocuments {
                                
                                let id = doc.documentID.description
                                let data = doc.data()
                                
                                
                                if let writingText = data["writing"] as? String, let emotionSender = data["emotion"] as? String , let timeSender = data["time"] as? Double, let switchSender = data["switch"] as? String {
                                    cnt += 1
                                    // 24시간제로 변경
                                    let date: DateFormatter = {
                                        let df = DateFormatter()
                                        df.locale = Locale(identifier: "ko_KR")
                                        df.timeZone = TimeZone(abbreviation: "KST")
                                        df.dateFormat = "dd"
                                        return df
                                    }()
                                    
                                    // 변경 후 적용
                                    let today = Int(timeSender)
                                    let timeInterval = TimeInterval(today)
                                    let day = Date(timeIntervalSince1970: timeInterval)
                                    let num = Int(date.string(from: day))!

                                    if dayCount.contains(num) == false{
                                        dayCount.append(num)
                                    }
                                    
                                    
                                    // 폰 기본 정보로 전달
                                    let UserDefaults = UserDefaults.standard
                                    UserDefaults.set(dayCount.count ,forKey: "count")
                                    
                                    
                                    // URL 생성
                                    let pathRef = self.storage.reference(withPath: "\(writingSender)/\(timeSender)")
                                    let makeurl = "https://firebasestorage.googleapis.com/v0/b/\(pathRef.bucket)/o/\(writingSender)%2F\(pathRef.name)?alt=media"
                                    
                                    // writing에 일기 기본정보들 저장
                                    self.writing.append(Writing(emtion: emotionSender, time: timeSender, writing: writingText, documentID: id, data: makeurl, deleteID: pathRef, switchID: switchSender))
                                    self.writing.sort(by: {$0.time < $1.time})
                                    self.hashTagTableView.reloadData()
                                    let indexPath = IndexPath(row: self.writing.count-1, section: 0)
                                    self.hashTagTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    
                                }
                            }
                            // 일기가 없을 시
                            if cnt == 0 {
                                self.writing.removeAll()
                                self.hashTagTableView.reloadData()
                                self.nothingText.text = "아무것도 작성하지 않았어요! 당신의 이야기를 적어주세요 😊"
                                self.nothingText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                self.nothingText.numberOfLines = 0
                                
                                let UserDefaults = UserDefaults.standard
                                UserDefaults.set(0 ,forKey: "count")
                            } else {
                                self.nothingText.text = ""
                            }
                        }
                    }
                }
        }
        
    }
    
    
    
    //MARK: - 테이블 뷰 소팅
    func update(_ sort: String, emotionType: String) {
        if let writingSender = Auth.auth().currentUser?.email {
            dataBase.collection(writingSender)
                .order(by: sort)
                .addSnapshotListener { QuertSnapshot, error in
                    self.writing = []
                    var dayCount: [Int] = []
                    if let e = error {
                        print("문제가 발생했습니다. \(e)")
                    } else {
                        
                        if let snapshotDocuments = QuertSnapshot?.documents {
                            var cnt = 0
                            for doc in snapshotDocuments {
                                let id = doc.documentID.description
                                let data = doc.data()
                                
                                if let writingText = data["writing"] as? String, let emotionSender = data["emotion"] as? String , let timeSender = data["time"] as? Double, let switchSender = data["switch"] as? String {
                                    if emotionSender == emotionType {
                                        
                                        cnt += 1
                                        // 24시간제로 변경
                                        let date: DateFormatter = {
                                            let df = DateFormatter()
                                            df.locale = Locale(identifier: "ko_KR")
                                            df.timeZone = TimeZone(abbreviation: "KST")
                                            df.dateFormat = "dd"
                                            return df
                                        }()
                                        
                                        // 시간 적용
                                        let today = Int(timeSender)
                                        let timeInterval = TimeInterval(today)
                                        let day = Date(timeIntervalSince1970: timeInterval)
                                        let num = Int(date.string(from: day))!
                                        //self.CircleStatus()
                                        if dayCount.contains(num) == false{
                                            dayCount.append(num)
                                        }
                                        
                                        // 폰 기본정보로 값 전달
                                        let UserDefaults = UserDefaults.standard
                                        UserDefaults.set(dayCount.count ,forKey: "count")
                                        
                                        // URL 생성
                                        let pathRef = self.storage.reference(withPath: "\(writingSender)/\(timeSender)")
                                        let makeurl = "https://firebasestorage.googleapis.com/v0/b/\(pathRef.bucket)/o/\(writingSender)%2F\(pathRef.name)?alt=media"
                                        
                                        // writing 정보 업데이트
                                        let newWriting = Writing(emtion: emotionSender, time: timeSender, writing: writingText, documentID: id, data: makeurl, deleteID: pathRef, switchID: switchSender)
                                        
                                        self.writing.append(newWriting)
                                        self.writing.sort(by: {$0.time < $1.time})
                                        self.hashTagTableView.reloadData()
                                        
                                        let indexPath = IndexPath(row: self.writing.count-1, section: 0)
                                        self.hashTagTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                    }
                                    
                                }
                            }
                            // 일기가 없을 시
                            if cnt == 0 {
                                self.writing.removeAll()
                                self.hashTagTableView.reloadData()
                                self.nothingText.text = "아무것도 작성하지 않았어요! 당신의 이야기를 적어주세요 😊"
                                self.nothingText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                                self.nothingText.numberOfLines = 0
                            } else {
                                self.nothingText.text = ""
                            }
                        }
                    }
                }
        }
    }
    
    
}

//MARK: - 테이블 뷰 익스텐션
extension HashTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(writing)
        print("writing Len : \(writing.count)")
        return writing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("writing Count: \(writing.count)")
        let cell: HashTagTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hashTagCell", for: indexPath) as! HashTagTableViewCell
        let writing = writing[indexPath.row]
        print()
        
        
        
        cell.writingText.text = writing.writing
        cell.writingText.textColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        cell.hashTagLabel.text = writing.emtion
        cell.hashTagLabel.textColor = #colorLiteral(red: 0.1834903555, green: 0.1986690177, blue: 0.2207198435, alpha: 1)
        print("Writing ID: \(writing.switchID)")
        
        cell.textImageView.kf.indicatorType = .activity
        let cache = ImageCache.default
        let retry = DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(2))
        
        // 일기에 사진이 있을 경우에만 이미지 뷰어 크기 설정
        if writing.switchID != "nil" {
            cache.retrieveImage(forKey: writing.data, options: nil) { c in
                cell.ImageViewHeight.constant = CGFloat(360)
                switch c {
                case .success(let value):
                    
                    if let image = value.image {
                        cell.textImageView.image = image
                    } else {
                        cell.textImageView.kf.setImage(with: URL(string: writing.data), options: [.transition(.fade(0.2)), .forceTransition, .keepCurrentImageWhileLoading, .retryStrategy(retry)])
                    }
                case .failure(let error):
                    print("서버 통신 중 오류 발생")
                }
            }
        } else {
            cell.ImageViewHeight.constant = CGFloat(0)
        }
        
            
        let date: DateFormatter = {
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.timeZone = TimeZone(abbreviation: "KST")
            df.dateFormat = "yyyy년 MM월dd일 HH시mm분"
            return df
        }()
        
        let today = Int(writing.time)
        let timeInterval = TimeInterval(today)
        let day = Date(timeIntervalSince1970: timeInterval)
        cell.trashButton.tag = indexPath.row
        cell.dayLabel.text = "\(date.string(from: day))"
        cell.dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        return cell
    }
    
    
}


// FireBase에 등록된 일기 제거할때 같이 제거되게 구현해야한다.
