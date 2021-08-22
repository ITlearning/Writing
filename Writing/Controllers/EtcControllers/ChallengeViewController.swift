//
//  ChallengeViewController.swift
//  Writing
//  챌린지 일수 선택하는 뷰
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
    var text = ["1일 작성하기", "5일 작성하기", "15일 작성하기", "30일 작성하기", "99일 작성하기"]
    var select = 0
    // 프로그래스 링
    let ringProgressView = [RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))]
    
    // 현재 게시글 수 - 지속적인 업데이트가 필요한 숫자
    // 나중에 파베서버에서 개수 땡겨와서 업데이트
    var nowWriting: Double = UserDefaults.standard.double(forKey: "count")
    @IBOutlet weak var challengeTableView: UITableView!
    
    //MARK: - 뷰가 보여지기 전
    override func viewWillAppear(_ animated: Bool) {
        update()
        self.challengeTableView.reloadData()
    }
    
    //MARK: - 뷰 초기 세팅
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("챌뷰컨 지금까지 작성한 것 \(nowWriting)")
        // Do any additional setup after loading the view.
        challengeTableView.rowHeight = UITableView.automaticDimension
        challengeTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        //challengeTableView.estimatedRowHeight = 600
        
    }

    //MARK: - 취소버튼
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    //MARK: - 작성완료 업데이트
    func update() {
        for i in 0..<5 {
            
            if nowWriting / Double(intro[i]) >= 1 {
                print("지금 작성된 거 : \(nowWriting), 개수 \(intro[i])")
                print("응 여기로 들어왔어, 이건 챌린지꺼야")
                text[i] = "작성 완료!"
            }else {
                text[i] = "\(intro[i])일 작성하기"
            }
        }
        print(text)
    }
    
}

//MARK: - 테이블 뷰 세팅
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
        
        circle.progress = nowWriting/Double(intro[indexPath.row])
        cell.circleLayer.addSubview(circle)
        cell.introduceLayer.text = text[indexPath.row]
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



