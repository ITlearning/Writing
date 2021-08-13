//
//  HomeViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import MKRingProgressView
import Firebase
import FirebaseFirestore
class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var buttonLayout: UIButton!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var challengeButton: UIView!
    @IBOutlet weak var ringProgress: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var challengeText: UIButton!
    let dataBase = Firestore.firestore()
    var lastOffsetY: CGFloat = 0
    let ringProgressView = RingProgressView(frame: CGRect(x: 5, y: 5, width: 60, height: 60))
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        appNameLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subLabel.textColor = #colorLiteral(red: 0.9306344697, green: 0.9306344697, blue: 0.9306344697, alpha: 1)
        //buttonLayout.imageView
        scrollView.delegate = self
        textLabel.text = "fhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjdsfhjds"
        
        ringProgressView.startColor = #colorLiteral(red: 0.00112261367, green: 0.7317003608, blue: 0.8825521469, alpha: 1)
        ringProgressView.endColor = #colorLiteral(red: 0.006783903111, green: 0.9808149934, blue: 0.8184377551, alpha: 1)
        ringProgressView.ringWidth = 8
        ringProgressView.progress = 0.7
        
        ringProgress.addSubview(ringProgressView)
        CircleStatus()
    }
    
    
    
    func CircleStatus() {
        //dataBase.
    }
    
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    @IBAction func bellButton(_ sender: UIButton) {
        print("Good")
        
    }
}

