//
//  HashTagTableViewCell.swift
//  Writing
//
//  Created by IT learning on 2021/08/11.
//

import UIKit

class HashTagTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var writingText: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //writingText.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
    }

    override var frame: CGRect {
        get {
            return super.frame
        }
        set(newFrame) {
            var frame = newFrame
            frame.size.height = UIScreen.main.bounds.height * 0.8
            super.frame = frame
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
