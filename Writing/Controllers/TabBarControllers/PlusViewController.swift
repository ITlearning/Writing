//
//  PlusViewController.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import UIKit
import FirebaseFirestore
import Firebase
import NotificationBannerSwift
import YPImagePicker
import SwiftOverlays
class PlusViewController: UIViewController, UITextViewDelegate {

    
    // UITextView
    @IBOutlet weak var writingTextField: UITextView!
    
    // UIButton
    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var boringButton: UIButton!
    @IBOutlet weak var noneButton: UIButton!
    
    // UILabel
    @IBOutlet weak var writingMainText: UILabel!
    @IBOutlet weak var writingSubText: UILabel!
    @IBOutlet weak var introduceText: UILabel!
    @IBOutlet weak var selectImageView: UIImageView!
    
    let storage = Storage.storage()
    var selectImage: UIImage?
    var btnArray = [UIButton]()
    var selectEmotion: String = "선택하지않음"
    var dataBase = Firestore.firestore()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        writingTextField.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        self.view.backgroundColor = #colorLiteral(red: 0.2261704771, green: 0.3057078214, blue: 0.3860993048, alpha: 1)
        
        
        btnArray.append(happyButton)
        btnArray.append(sadButton)
        btnArray.append(boringButton)
        btnArray.append(noneButton)
        writingTextField.layer.borderWidth = 3
        writingTextField.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        writingTextField.layer.cornerRadius = 5
        writingTextField.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        writingMainText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        writingSubText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        introduceText.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        buttonSetting()
        placeholderSetting()
    }
    
    //MARK: - 플레이스 홀더 세팅
    func placeholderSetting() {
        self.writingTextField.delegate = self
        writingTextField.text = "이곳에 오늘 하루를 입력해주세요!"
        writingTextField.textColor = UIColor.lightGray
    }
    
    //MARK: - 텍스트 뷰에서 작성이 시작됐을 때 설정
    func textViewDidBeginEditing(_ textView: UITextView) {
        if writingTextField.textColor == UIColor.lightGray {
            writingTextField.text = nil
            writingTextField.textColor = UIColor.white
        }
    }
    
    //MARK: - 텍스트 뷰에서 작성이 끝났을 때 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        if writingTextField.text.isEmpty {
            writingTextField.text = "이곳에 오늘 하루를 입력해주세요!"
            writingTextField.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - 버튼 설정
    func buttonSetting() {
        happyButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        happyButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        happyButton.layer.cornerRadius = 20
        
        sadButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        sadButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        sadButton.layer.cornerRadius = 20
        
        boringButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        boringButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        boringButton.layer.cornerRadius = 20
        
        noneButton.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        noneButton.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        noneButton.layer.cornerRadius = 20
    }
    
    func uploadImage(img: UIImage, time: Double) {
        let text = "사진 업로드 중.."
        self.showWaitOverlayWithText(text)
        var data = Data()
        data = img.jpegData(compressionQuality: 0.8)!
        let filePath = "\(String(describing: Auth.auth().currentUser?.email))/\(time)"
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage.reference().child(filePath).putData(data, metadata:  metaData) {
            (metaData,error) in if let error = error {
                print("에러 \(error)")
                return
            } else {
                self.removeAllOverlays()
                let banner = NotificationBanner(title: "등록 성공!", subtitle: "소중한 하루정리를 안전하게 업로드했어요! 👍🏻",style: .success)
                banner.show()
                self.writingTextField.text = ""
                self.selectImageView.image = nil
                print("성공!")
            }
        }
    }
    
    //MARK: - 전송 버튼
    @IBAction func sendButton(_ sender: UIButton) {
        
        if writingTextField.text.isEmpty {
            print("아무것도 입력하지 않았습니다.")
        }
        if let writing = writingTextField.text, let writingSender = Auth.auth().currentUser?.email {
            
            if (!writing.isEmpty && writing != "이곳에 오늘 하루를 입력해주세요!") && selectEmotion != "선택하지않음" {
                let time = Date().timeIntervalSince1970
                dataBase.collection((String(describing: Auth.auth().currentUser?.email))).addDocument(data: [
                    "sender": writingSender,
                    "writing": writing,
                    "emotion": selectEmotion,
                    "time": time
                ]) { error in
                    if let e = error {
                        print("업로드 중 에러 발생\(e)")
                    } else {
                        DispatchQueue.main.async {
                            let image = self.selectImage
                            if image != nil {
                                self.uploadImage(img: image!, time: time)
                                self.selectImage = nil
                            } else {
                                self.writingTextField.text = ""
                                let banner = NotificationBanner(title: "등록 성공!", subtitle: "소중한 하루정리를 안전하게 업로드했어요! 👍🏻",style: .success)
                                banner.show()
                            }
                        }
                        
                        
                        
                        print("데이터 전송 성공!")
                    }
                }
            } else {
                let banner = NotificationBanner(title: "오류발생!", subtitle: "오늘 하루를 작성해주시거나, 작성했다면 기분을 선택하지 않았는지 확인해주세요 :)", style: .danger)
                banner.show()
            }
        }
    }
    
    
    //MARK: - 감정 선택 버튼 세팅
    @IBAction func selectOptionBtnAction(_ sender: UIButton) {
           for btn in btnArray {
            guard let button = sender as? UIButton else { return }
            if btn == button  {
                if !button.isSelected {
                    button.isSelected = true
                    button.tintColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                    button.backgroundColor = #colorLiteral(red: 0.7633925159, green: 0.4070249483, blue: 0.2914104231, alpha: 1)
                    selectEmotion = (button.titleLabel?.text)!
                } else {
                    button.isSelected = false
                    button.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    button.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    selectEmotion = "선택하지않음"
                }
            } else {
                btn.isSelected = false
                btn.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                btn.tintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
            }
        }
    }
    
    
    
    @IBAction func photoSelectButton(_ sender: UIButton) {
        let picker = YPImagePicker()
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print("카메라 이미지 소스 : \(photo.fromCamera)")
                print("최종적으로 선택한 이미지: \(photo.image)")
                print("오리지날 이미지: \(photo.originalImage)")
                print("변경한 이미지 : \(photo.modifiedImage)")
                print("이미지의 메타 데이터: \(String(describing: photo.exifMeta))")
                
                self.selectImageView.image = photo.image
                self.selectImage = photo.image
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        present(picker, animated: true, completion: nil)
    }
}
