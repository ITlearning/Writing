//
//  SearchViewController.swift
//  Writing
//  사진 뷰 컨트롤러
//  Created by IT learning on 2021/08/09.
//

import UIKit
import FirebaseStorage
import Firebase
import ImageViewer_swift
import Kingfisher
import AlignedCollectionViewFlowLayout

class SearchViewController: UIViewController{
    
    //MARK: - Status Bar 색 설정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    //MARK: - 화면이 나타났을 때
    override func viewDidAppear(_ animated: Bool) {
        callWriting()
    }
    
    //MARK: - Label과 Collection View
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var photoText: UILabel!
    @IBOutlet weak var subText: UILabel!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    // 기본 변수들
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
        let alignedFlowLayout = searchCollectionView.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        //alignedFlowLayout?.minimumLineSpacing = 2
        alignedFlowLayout?.verticalAlignment = .center
        callWriting()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - 사진 불러오기
    func callWriting() {
        if let writingSender = Auth.auth().currentUser?.email {
            dataBase.collection(writingSender).order(by: "time").addSnapshotListener { QuertSnapshot, error in
                self.writing = []
                
                if let e = error {
                    print("문제가 발생했습니다. \(e)")
                } else {
                    if let snapshotDocument = QuertSnapshot?.documents {
                        var cnt = 0
                        for doc in snapshotDocument {
                            
                            let data = doc.data()
                            
                            if let writingText = data["writing"] as? String, let timeSender = data["time"] as? Double {
                                cnt += 1
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
                        if cnt == 0 {
                            self.writing.removeAll()
                            self.searchCollectionView.reloadData()
                            self.emptyLabel.text = "아무것도 작성하지 않았어요! 당신의 이야기를 적어주세요 😊"
                            self.emptyLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                            
                        } else {
                            self.emptyLabel.text = ""
                        }
                    }
                }
            }
        }
    }

}


//MARK: - 컬렉션 뷰 정의 익스텐션
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Writing Count: \(writing.count)")
        return writing.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.invalidateLayout()
        
        return CGSize(width: ((self.view.frame.width/3)-3), height: ((self.view.frame.width/3)-3))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SearchCollectionViewCell
        print("Writing Array:\(self.writing)")
        
        let writing = writing[indexPath.row]
        
        print("Writing Index: \(writing)")
        cell.backgroundColor = .lightGray
        cell.imageView.kf.indicatorType = .activity
        let cache = ImageCache.default
        let retry = DelayRetryStrategy(maxRetryCount: 3, retryInterval: .seconds(1))
        
        // 캐시가 있는 상황 구별
        cache.retrieveImage(forKey: writing.data, options: nil) { c in
            switch c {
            case .success(let value):
                if let image = value.image {
                    cell.imageView.image = image
                    cell.imageView.setupImageViewer()
                    
                } else {
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
