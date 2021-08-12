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

    
    @IBOutlet weak var hashTagTableView: UITableView!
    
    var writing: [Writing] = []
    
    let dataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashTagTableView.delegate = self
        hashTagTableView.dataSource = self
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        hashTagTableView.register(UINib(nibName: "HashTagTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        loadWriting()
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

extension HashTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return writing.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let writing = writing[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! HashTagTableViewCell
        cell.writingText.text = writing.writing
        cell.hashTagLabel.text = writing.emtion
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
        return cell
    }
    
    
}
