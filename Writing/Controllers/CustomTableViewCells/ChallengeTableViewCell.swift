//
//  challengeTableViewCell.swift
//  Writing
//
//  Created by IT learning on 2021/08/11.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {

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
