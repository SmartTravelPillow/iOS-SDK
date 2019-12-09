//
//  AccountManager.swift
//  SDK Demo
//
//  Created by BB9z on 2019/11/18.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

import Foundation

/**
 演示用账户管理
 */
class AccountManager {
    private lazy var store = UserDefaults.standard

    /// 当前用户的 ID
    var userID: String? {
        get {
            store.string(forKey: "UserID")
        }
        set {
            if let newRecord = newValue {
                var history = historyUserIDList
                if !history.contains(newRecord) {
                    history.append(newRecord)
                }
                historyUserIDList = history
            }
            store.set(newValue, forKey: "UserID")
            let r = store.synchronize()
            assert(r)
        }
    }

    /// 返回当前用户 ID；如果没有，则创建一个新的并使之成为当前用户
    func lastUserOrCreateNewOne() -> String {
        guard let uid = userID else {
            let uid = createNewUserID()
            userID = uid
            return uid
        }
        return uid
    }

    /// 生成一个新的用户 ID
    func createNewUserID() -> String {
        return NSUUID().uuidString
    }

    /// 历史用户记录
    var historyUserIDList: [String] {
        get {
            store.array(forKey: "UserHiistory") as? [String] ?? [String]()
        }
        set {
            store.set(newValue, forKey: "UserHiistory")
            let r = store.synchronize()
            assert(r)
        }
    }
}
