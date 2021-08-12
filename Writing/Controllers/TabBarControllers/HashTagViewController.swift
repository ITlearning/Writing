//
//  HashTagViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import FirebaseFirestore
class HashTagViewController: UIViewController {

    
    @IBOutlet weak var viewMainName: UILabel!
    @IBOutlet weak var viewSubName: UILabel!
    @IBOutlet weak var hashTagTableView: UITableView!
    
    var writing: [Writing] = []
    
    let dataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagTableView.delegate = self
        hashTagTableView.dataSource = self
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        hashTagTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        loadWriting()
        viewMainName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        viewSubName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    

    func loadWriting() {
        dataBase.collection("WritingDB")
            .order(by: "time")
            .addSnapshotListener { QuertSnapshot, error in
                self.writing = []
                
                if let e = error {
                    print("문제가 발생했습니다. \(e)")
                } else {
                    if let snapshotDocuments = QuertSnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let writingText = data["writing"] as? String, let emotionSender = data["emotion"] as? String , let timeSender = data["time"] as? Double {
                                let newWriting = Writing(emtion: emotionSender, time: timeSender, writing: writingText)
                                self.writing.append(newWriting)
                                
                                self.hashTagTableView.reloadData()
                                    
                                let indexPath = IndexPath(row: self.writing.count-1, section: 0)
                                self.hashTagTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
    }
    

}
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
        
        cell.dayLabel.text = "\(date.string(from: day))"
        cell.dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            writing.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
}


// FireBase에 등록된 일기 제거할때 같이 제거되게 구현해야한다.
