//
//  SearchViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import FirebaseStorage
import Firebase
import ImageViewer_swift
import Kingfisher
class SearchViewController: UIViewController{
    
    
    override func viewDidAppear(_ animated: Bool) {
        callWriting()
    }
    
    @IBOutlet weak var photoText: UILabel!
    @IBOutlet weak var subText: UILabel!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    let dataBase = Firestore.firestore()
    var writing: [PhotoWriting] = []
    let image = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
    let storage = Storage.storage()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        photoText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        subText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.searchCollectionView.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        self.searchCollectionView.delegate = self
        self.searchCollectionView.dataSource = self
        callWriting()
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
                            
                            if let writingText = data["writing"] as? String, let timeSender = data["time"] as? Double {
                                let pathRef = self.storage.reference(withPath: "\(writingSender)/\(timeSender)")
                                let makeurl = "https://firebasestorage.googleapis.com/v0/b/\(pathRef.bucket)/o/\(writingSender)%2F\(pathRef.name)?alt=media"
                                let newWriting = PhotoWriting(time: timeSender, writing: writingText, data: makeurl)
                                let imageView = UIImageView()
                                imageView.kf.setImage(with: URL(string: makeurl)) { result in
                                    switch result {
                                    case .success(let value):
                                        self.writing.append(newWriting)
                                        self.writing.sort(by: {$0.time < $1.time})
                                        self.searchCollectionView.reloadData()
                                    case .failure(let error):
                                        print("에러")
                                    }
                                }
                                
                            }
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return writing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3-1
//        if indexPath.row % 7 == 0 {
//            let size = CGSize(width: width, height: width*2)
//
//            return size
//        } else {
//            let size = CGSize(width: width, height: width)
//            return size
//        }
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        print("Writing Array:\(self.writing)")
        let writing = writing[indexPath.row]
        
        cell.backgroundColor = .lightGray
        cell.imageView.kf.indicatorType = .activity
        let cache = ImageCache.default
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(1))
        cache.retrieveImage(forKey: writing.data, options: nil) { c in
            switch c {
            case .success(let value):
                let width = collectionView.frame.width/3-1
                if let image = value.image {
                    //image.draw(in: CGRect(x: 0, y: 0, width: width, height: width*2))
                    //cell.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: width))
                    cell.imageView.image = image
                    cell.imageView.setupImageViewer()
                    
                } else {
                    let width = collectionView.frame.width/3-1
                    cell.imageView.kf.setImage(with: URL(string: writing.data), options: [.transition(.fade(0.2)), .forceTransition, .loadDiskFileSynchronously, .retryStrategy(retry)])
                    cell.imageView.setupImageViewer()
                }
            case .failure(let error):
                print("이미지 에러")
            }
            
        }
        
        return cell
        
    }
    
    
}
