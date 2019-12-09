//
//  AppDelegate.swift
//  SDK Demo
//
//  Created by BB9z on 2019/10/11.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

import UIKit
import SmartTravelPillow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var appID = "YOUR_APP_ID"
        if let lastAppID = lastAppID {
            appID = lastAppID
        }
        SmartTravelPillow.setup(appID: appID, luanchOption: launchOptions)

        // 推荐通过 window 设置全局颜色，SDK 界面将随全局颜色变化
        window?.tintColor = UIColor(named: "tint")
        // 控制 SDK 页面中随主题色变色的控件文字的颜色
        SmartTravelPillow.isContolUsingDarkText = false
        return true
    }

    @IBAction func onChangeAppID(_ sender: Any) {
        let alert = UIAlertController(title: "切换 App ID", message: "变更需要重启生效", preferredStyle: .alert)
        var textField: UITextField!
        alert.addTextField { tf in
            textField = tf
            tf.text = self.lastAppID
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "切换", style: .default, handler: { _ in
            if let text = textField.text {
                self.lastAppID = text.count > 0 ? text : nil
            }
        }))
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }

    var lastAppID: String? {
        get {
            UserDefaults.standard.string(forKey: "Last SDK AppID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "Last SDK AppID")
        }
    }
}
