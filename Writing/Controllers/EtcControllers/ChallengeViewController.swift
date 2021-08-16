//
//  ChallengeViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/11.
//

import UIKit
import MKRingProgressView
import FirebaseFirestore

class ChallengeViewController: UIViewController {
    
    // 레벨을 가리킴
    let level = ["1","2","3","4","5"]
    
    // 레벨에 해당하는 개수
    let intro = [1, 5, 15, 30, 99]
    var select = 0
    // 프로그래스 링
    let ringProgressView = [RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))]
    
    // 현재 게시글 수 - 지속적인 업데이트가 필요한 숫자
    // 나중에 파베서버에서 개수 땡겨와서 업데이트
    var nowWriting: Double = 3
    
    override func viewDidDisappear(_ animated: Bool) {
        print("닫힙니다")
        
        //hvc.contribute()
    }
    
    @IBOutlet weak var challengeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        challengeTableView.rowHeight = UITableView.automaticDimension
        challengeTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        //challengeTableView.estimatedRowHeight = 600
        select = UserDefaults.standard.integer(forKey: "index")
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension ChallengeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return level.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChallengeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "challengeCell", for: indexPath) as! ChallengeTableViewCell
        let circle = ringProgressView[indexPath.row]
        circle.startColor = #colorLiteral(red: 0.00112261367, green: 0.7317003608, blue: 0.8825521469, alpha: 1)
        circle.endColor = #colorLiteral(red: 0.006783903111, green: 0.9808149934, blue: 0.8184377551, alpha: 1)
        circle.ringWidth = 8
        print(nowWriting/Double(intro[indexPath.row]))
        
        
        
        // 아직 챌린지 깻으면 도전 성공 안뜬다.
        // 확인하자.
        
        circle.progress = nowWriting/Double(intro[indexPath.row])
        cell.circleLayer.addSubview(circle)
        if nowWriting/Double(intro[indexPath.row]) >= 1 {
            cell.introduceLayer.text = "챌린지 도전 성공!"
        }
        cell.introduceLayer.text = "\(intro[indexPath.row])일 작성하기"
        cell.levelLayer.text = "LEVEL"+level[indexPath.row]
        print(select)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "챌린지", message: "선택한 챌린지로 바꿀까요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        // 선택 버튼을 눌렀을 시 구현 코드
        let selectAction = UIAlertAction(title: "선택", style: .default) { [self] _ in
            //self.select = indexPath.row
            let UserDefaults = UserDefaults.standard
            guard let vc = self.storyboard?.instantiateViewController(identifier: "HomeView") as? HomeViewController else { return }
            
            UserDefaults.set(indexPath.row ,forKey: "index")
            self.dismiss(animated: true) {
                vc.index = indexPath.row
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(selectAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    
}



