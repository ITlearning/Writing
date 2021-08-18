//
//  MainViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import Firebase
import Tabman
import Pageboy

class MainViewController: TabmanViewController {

    private var viewControllers: Array<UIViewController> = []
    
    
    @IBOutlet weak var barBackground: UIView!
    let barIcon = [UIImage(systemName: "house.fill"), UIImage(systemName: "text.magnifyingglass"), UIImage(systemName: "plus.app.fill"), UIImage(systemName: "number"), UIImage(systemName: "ellipsis")]
    let barText = ["홈", "검색", "글쓰기", "태그", "더 보기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewSetting()
        
        self.dataSource = self
        
        let bar = TMBar.TabBar()
        
        bar.layout.transitionStyle = .progressive
        bar.scrollMode = .interactive
        bar.backgroundView.style = .custom(view: barBackground)
        
        bar.layout.contentInset = UIEdgeInsets(top: 3, left: 10, bottom: 5, right: 10)
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = #colorLiteral(red: 0.1181788589, green: 0.1181788589, blue: 0.1181788589, alpha: 1)
            button.imageContentMode = .scaleAspectFit
            
            //button.imageViewSize = CGSize(width: 35, height: 35)
        }
        addBar(bar, dataSource: self, at: .bottom)
    }
    
    func viewSetting() {
        let home = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        let search = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchView") as! SearchViewController
        let plus = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlusView") as! PlusViewController
        let hash = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HashTagView") as! HashTagViewController
        let more = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MoreView") as! MoreViewController
        
        viewControllers.append(home)
        viewControllers.append(search)
        viewControllers.append(plus)
        viewControllers.append(hash)
        viewControllers.append(more)
        
        barBackground.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        barBackground.layer.cornerRadius = 20
        barBackground.layer.maskedCorners = CACornerMask(arrayLiteral:  .layerMinXMinYCorner, .layerMaxXMinYCorner)
        barBackground.layer.shadowColor = UIColor.black.cgColor
        barBackground.layer.masksToBounds = false
        barBackground.layer.shadowOffset = CGSize(width: 0, height: 3)
        barBackground.layer.shadowRadius = 3
        barBackground.layer.shadowOpacity = 0.3
        barBackground.layer.borderWidth = 0.5
        barBackground.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
    }
    
}

extension MainViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        item.title = barText[index]
        
        let icon = barIcon[index]
        
        item.image = icon
        return item
    }
}
