//
//  UserInfo.swift
//  BrainBurst
//
//  Created by 고대원 on 2023/06/10.
//

import Foundation

struct UserInfo {
    fileprivate static let NICK_NAME_KEY: String = "NICK_NAME"
    fileprivate static let UUID_KEY: String = "UUID"
    
    private init() {}
    
    static var uuid: String {
        get {
            let uuidString = UUID().uuidString
            if UserDefaults.standard.object(forKey: UserInfo.UUID_KEY) as? String == nil {
                UserDefaults.standard.setValue(uuidString, forKey: UserInfo.UUID_KEY)
            }
            
            return UserDefaults.standard.object(forKey: UserInfo.UUID_KEY) as? String ?? ""
        }
        set {
            if UserDefaults.standard.object(forKey: UserInfo.UUID_KEY) as? String == nil {
                UserDefaults.standard.setValue(newValue, forKey: UserInfo.UUID_KEY)
            }
        }
    }
    
    static var nickName: String {
        get {
            return UserDefaults.standard.object(forKey: UserInfo.NICK_NAME_KEY) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserInfo.NICK_NAME_KEY)
        }
    }
}
