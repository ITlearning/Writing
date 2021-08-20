//
//  SearchViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import SquareFlowLayout
import FirebaseStorage
import Firebase
import SquareFlowLayout

class SearchViewController: UIViewController, SquareFlowLayoutDelegate {
    
    func shouldExpandItem(at indexPath: IndexPath) -> Bool {
        return (0 != 0)
    }
    
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    let dataBase = Firestore.firestore()
    var writing: [Writing] = []
    let image = [UIImage(systemName: "sun"),UIImage(systemName: "sun"),UIImage(systemName: "sun"),UIImage(systemName: "sun"),UIImage(systemName: "sun"),UIImage(systemName: "sun")]
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = SquareFlowLayout()
        flowLayout.flowDelegate = self
        self.searchCollectionView.collectionViewLayout = flowLayout
        // Do any additional setup after loading the view.
    }
    
    func callWriting() {
        if let writingSender = Auth.auth().currentUser?.email {
            dataBase.collection(writingSender).order(by: "time").addSnapshotListener { QuertSnapshot, error in
                self.writing = []
                
                if let e = error {
                    print("문제가 발생했습니다. \(e)")
                } else {
                    if let snapshotDocument = QuertSnapshot?.documents {
                        for doc in snapshotDocument {
                            let data = doc.data()
                            
                            //if let writingText = data["writing"] as? String, let emotionSender = data["emotion"]
                        }
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
