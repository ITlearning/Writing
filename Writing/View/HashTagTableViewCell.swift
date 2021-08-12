//
//  HashTagTableViewCell.swift
//  Writing
//
//  Created by IT learning on 2021/08/11.
//

import UIKit

class HashTagTableViewCell: UITableViewCell {

    @IBOutlet weak var writingText: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var writingView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        writingText.layer.cornerRadius = 10
        //writingText.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
