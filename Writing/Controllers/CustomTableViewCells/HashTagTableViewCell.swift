//
//  HashTagTableViewCell.swift
//  Writing
//  해시태그 뷰 커스텀 셀
//  Created by IT learning on 2021/08/11.
//

import UIKit
import Firebase
class HashTagTableViewCell: UITableViewCell {

    @IBOutlet weak var writingText: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var writingView: UIView!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var textImageView: UIImageView!
    @IBOutlet weak var ImageViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        writingText.layer.cornerRadius = 10
        //aspectConstraint = nil
        //writingText.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        
    }
    override func prepareForReuse() {
        self.writingText.text = .none
        self.dayLabel.text = .none
        self.hashTagLabel.text = .none
        self.writingText.text = .none
        self.textImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
