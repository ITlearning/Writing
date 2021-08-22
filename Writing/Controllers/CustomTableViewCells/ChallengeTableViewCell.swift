//
//  challengeTableViewCell.swift
//  Writing
//  챌린지 선택 뷰 커스템 셀
//  Created by IT learning on 2021/08/11.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    //MARK: - 테이블 뷰 셀 구성요소들
    @IBOutlet weak var circleLayer: UIView!
    @IBOutlet weak var levelLayer: UILabel!
    @IBOutlet weak var introduceLayer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
