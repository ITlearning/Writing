//
//  HashTagViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import FirebaseFirestore
import NotificationBannerSwift
class HashTagViewController: UIViewController {

    
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
    
    
    var writing: [Writing] = []
    var btnArray = [UIButton]()
    let dataBase = Firestore.firestore()
    var emotionStatus: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagTableView.delegate = self
        hashTagTableView.dataSource = self
        // 테이블 뷰 셀 나누는 칸 없애기
        hashTagTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        
        hashTagTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        loadWriting()
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
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        print(sender.tag)
        let alert = UIAlertController(title: "일기삭제", message: "선택한 일기를 삭제할까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel,handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            print(self.writing[sender.tag].time)
            self.dataBase.collection((String(describing: Auth.auth().currentUser?.email))).document(self.writing[sender.tag].documentID).delete() { err in
                if let err = err {
                    let banner = NotificationBanner(title: "에러발생", subtitle: "\(err)!", style: .danger)
                    banner.show()
                } else {
                    let banner = NotificationBanner(title: "삭제완료", subtitle: "일기를 성공적으로 삭제했어요!", style: .success)
                    banner.show()
                }
            }
            self.writing.remove(at: sender.tag)
            if self.emotionStatus! == "선택안됨" {
                self.hashTagTableView.reloadData()
            } else {
                self.update("emotion", emotionType: self.emotionStatus!)
            }
            if self.writing.count == 0 {
                self.nothingText.text = "아무것도 작성하지 않았어요! 당신의 이야기를 적어주세요 😊"
                self.nothingText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.nothingText.numberOfLines = 0
            } else {
                self.nothingText.text = ""
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func sortButton(_ sender: UIButton) {
        for btn in btnArray {
         guard let button = sender as? UIButton else { return }
         if btn == button  {
             if !button.isSelected {
                
                button.isSelected = true
                button.tintColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                emotionStatus = (button.titleLabel?.text)!
                update("emotion", emotionType: emotionStatus!)
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
        dataBase.collection((String(describing: Auth.auth().currentUser?.email)))
            .order(by: "time")
            .addSnapshotListener { QuertSnapshot, error in
                self.writing = []
                
                if let e = error {
                    print("문제가 발생했습니다. \(e)")
                } else {
                    if let snapshotDocuments = QuertSnapshot?.documents {
                        for doc in snapshotDocuments {
                            let id = doc.documentID.description
                            let data = doc.data()
                            
                            if let writingText = data["writing"] as? String, let emotionSender = data["emotion"] as? String , let timeSender = data["time"] as? Double {
                                let newWriting = Writing(emtion: emotionSender, time: timeSender, writing: writingText, documentID: id)
                                self.writing.append(newWriting)
                                
                                self.hashTagTableView.reloadData()
                                    
                                let indexPath = IndexPath(row: self.writing.count-1, section: 0)
                                self.hashTagTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            // 일기를 아무것도 작성하지 않았다면
                            if self.writing.count == 0 {
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
    
    //MARK: - 테이블 뷰 소팅
    func update(_ sort: String, emotionType: String) {
        dataBase.collection((String(describing: Auth.auth().currentUser?.email)))
            .order(by: sort)
            .addSnapshotListener { QuertSnapshot, error in
                self.writing = []
                
                if let e = error {
                    print("문제가 발생했습니다. \(e)")
                } else {
                    if let snapshotDocuments = QuertSnapshot?.documents {
                        for doc in snapshotDocuments {
                            let id = doc.documentID.description
                            let data = doc.data()
                            
                            if let writingText = data["writing"] as? String, let emotionSender = data["emotion"] as? String , let timeSender = data["time"] as? Double {
                                if emotionSender == emotionType {
                                    let newWriting = Writing(emtion: emotionSender, time: timeSender, writing: writingText, documentID: id)
                                    self.writing.append(newWriting)
                                    
                                    self.hashTagTableView.reloadData()
                                    
                                    let indexPath = IndexPath(row: self.writing.count-1, section: 0)
                                    self.hashTagTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                            // 일기를 아무것도 작성하지 않았다면
                            if self.writing.count == 0 {
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
var SelectedIndexPath = IndexPath()
extension HashTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         SelectedIndexPath = indexPath
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let writing = writing[indexPath.row]
        
        let cell: HashTagTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hashTagCell", for: indexPath) as! HashTagTableViewCell
        cell.writingText.text = writing.writing
        cell.writingText.textColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        cell.hashTagLabel.text = writing.emtion
        cell.hashTagLabel.textColor = #colorLiteral(red: 0.1834903555, green: 0.1986690177, blue: 0.2207198435, alpha: 1)
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
