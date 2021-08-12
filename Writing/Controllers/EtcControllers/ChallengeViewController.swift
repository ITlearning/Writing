//
//  ChallengeViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/11.
//

import UIKit
import MKRingProgressView
class ChallengeViewController: UIViewController {
    
    // 레벨을 가리킴
    let level = ["1","2","3","4","5"]
    
    // 레벨에 해당하는 개수
    let intro = [1, 5, 15, 30, 99]
    
    // 프로그래스 링
    let ringProgressView = [RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50)),RingProgressView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))]
    
    // 현재 게시글 수 - 지속적인 업데이트가 필요한 숫자
    // 나중에 파베서버에서 개수 땡겨와서 업데이트
    let nowWriting: Double = 3
    
    @IBOutlet weak var challengeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        challengeTableView.rowHeight = UITableView.automaticDimension
        challengeTableView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        //challengeTableView.estimatedRowHeight = 600
        
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
        circle.progress = nowWriting/Double(intro[indexPath.row])
        cell.circleLayer.addSubview(circle)
        cell.introduceLayer.text = "\(intro[indexPath.row])일 작성하기"
        cell.levelLayer.text = "LEVEL"+level[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    
    
}
