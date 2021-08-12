//
//  ErrorModel.swift
//  Writing
//
//  Created by IT learning on 2021/08/09.
//

import Foundation

struct ErrorModel {
    let error: String
    var krError: String {
        switch error {
        case "The password is invalid or the user does not have a password.":
            return "비밀번호가 틀렸거나, 비밀번호를 입력하지 않았습니다."
        case "The email address is badly formatted.":
            return "이메일 형식이 잘못되었습니다."
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            return "존재하는 이메일이 아닙니다. 이메일을 다시 확인해주십시오."
        case "The password must be 6 characters long or more.":
            return "비밀번호는 6자리가 넘어야 합니다."
        case "The email address is already in use by another account.":
            return "이 이메일은 이미 가입된 이메일입니다."
        default:
            return "에러 발생"
        }
    }
}
