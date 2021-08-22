//
//  Writing.swift
//  Writing
//  일기 서버 파싱 모델
//  Created by IT learning on 2021/08/11.
//

import UIKit
import FirebaseStorage
struct Writing {
    let emtion : String
    let time: Double
    let writing: String
    let documentID: String
    let data: String
    let deleteID: StorageReference
    let switchID: String
}
