//
//  MainViewController.swift
//  SDK Demo
//
//  Created by BB9z on 2019/10/11.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

import UIKit
import SmartTravelPillow

class MainViewController: UIViewController {

    lazy var account = AccountManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = SmartTravelPillow.versionDescription
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        darkTextSwitch.isOn = SmartTravelPillow.isContolUsingDarkText
        updateUIForAppIDChanges()
        updateUIForUserIDChanges()
        updateUIForNavigationStyleChange()
        isObservingAppIDExpireChange = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isObservingAppIDExpireChange = false
    }

    @IBOutlet weak var versionLabel: UILabel!

    // MARK: - 外观定制
    @IBAction func onChangeTintToDefault(_ sender: Any) {
        view.window?.tintColor = UIColor(named: "tint")
        // 如果 Storyboard 中的 global tint 不是默认值，相当于在每一个 vc 的 view 上设置了 tintColor
        // 需要手动将 view 的 tintColor 置空
    }

    @IBAction func onChangeTint(_ sender: UIButton) {
        view.window?.tintColor = sender.titleColor(for: .normal)
    }

    @IBOutlet weak var darkTextSwitch: UISwitch!
    @IBAction func onChangeDarkText(_ sender: Any) {
        SmartTravelPillow.isContolUsingDarkText = darkTextSwitch.isOn
    }

    @IBAction func onChangeNavigationBarStyleReset(_ sender: Any) {
        SmartTravelPillow.navigationBarBackgroundColor = nil
        SmartTravelPillow.navigationBarItemColor = nil
        SmartTravelPillow.statusBarStyle = .default
    }

    @IBAction func onChangeNavigationBarStyle(_ sender: UIButton) {
        SmartTravelPillow.navigationBarBackgroundColor = sender.backgroundColor
        SmartTravelPillow.navigationBarItemColor = sender.titleColor(for: .normal)
        if #available(iOS 13.0, *) {
            SmartTravelPillow.statusBarStyle = .darkContent
        } else {
            SmartTravelPillow.statusBarStyle = .default
        }
    }

    @IBAction func onChangeNavigationBarStyleLight(_ sender: UIButton) {
        SmartTravelPillow.navigationBarBackgroundColor = sender.backgroundColor
        SmartTravelPillow.navigationBarItemColor = sender.titleColor(for: .normal)
        SmartTravelPillow.statusBarStyle = .lightContent
    }

    @IBOutlet weak var customNavigationStyleButton: UIButton!
    func updateUIForNavigationStyleChange() {
        if let color = SmartTravelPillow.navigationBarBackgroundColor {
            customNavigationStyleButton.backgroundColor = color
        }
        if let color = SmartTravelPillow.navigationBarItemColor {
            customNavigationStyleButton.setTitleColor(color, for: .normal)
        }
    }

    // MARK: - App ID 状态

    @IBOutlet weak var appIDLabel: UILabel!
    @IBOutlet weak var appIDExpireLabel: UILabel!
    private var isObservingAppIDExpireChange: Bool = false {
        didSet {
            if (oldValue == isObservingAppIDExpireChange) { return }
            if (isObservingAppIDExpireChange) {
                NotificationCenter.default.addObserver(self, selector: #selector(updateUIForAppIDChanges), name: .HYSDKAppIDExpireChanged, object: nil)
            }
            else {
                NotificationCenter.default.removeObserver(self, name: .HYSDKAppIDExpireChanged, object: nil)
            }
        }
    }
    @objc func updateUIForAppIDChanges() {
        appIDLabel.text = SmartTravelPillow.appID
        appIDExpireLabel.text = SmartTravelPillow.appIDExpire?.description ?? "?"
    }

    // MARK: - 用户

    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var appUserIDLabel: UILabel!
    func updateUIForUserIDChanges() {
        userIdentifierLabel.text = SmartTravelPillow.userIdentifier ?? "?"
        appUserIDLabel.text = account.userID ?? "?"
    }

    @IBAction func onLogout(_ sender: Any) {
        SmartTravelPillow.userIdentifier = nil
        updateUIForUserIDChanges()
    }

    @IBAction func onCustomUserID(_ sender: Any) {
        let alert = UIAlertController(title: "切换 User ID", message: nil, preferredStyle: .alert)
        var textField: UITextField!
        alert.addTextField { tf in
            textField = tf
            tf.text = self.appUserIDLabel.text
            tf.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "切换", style: .default, handler: { _ in
            if let text = textField.text, !text.isEmpty {
                self.account.userID = text
                self.updateUIForUserIDChanges()
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    // MARK: -

    @IBAction func onEnterSDK(_ sender: UIControl?) {
        // Demo 中 userIdentifier 在进入 SDK 页面前设置，另一种通用的做法是在 app 当前用户变更时进行切换
        SmartTravelPillow.userIdentifier = account.lastUserOrCreateNewOne()
        SmartTravelPillow.presentSDKScenes(from: self, options: nil, complation: nil)
        /* 示例错误处理
            guard let e = error as NSError? else {
                // 进入成功
                return
            }
            // 下面进行错误处理
            debugPrint(e.localizedDescription)
            guard let code = HYJumpScenesError(rawValue: e.code) else {
                debugPrint("其它错误")
                return
            }
            switch code {
            case .appIDInvaild, .userIDNotSet:
                assertionFailure("配置错误")
            case .appIDExpired:
                debugPrint("App ID 过期")
            case .invaildOption:
                assertionFailure("参数错误")
            @unknown default:
                fatalError()
            }
         */
    }

    @IBAction func onCheckCanEnterSDK(_ sender: Any) {
        var error: NSError?
        if SmartTravelPillow.canPresentSDKScenesError(&error) {
            let alert = UIAlertController(title: "可以进入", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "不能进入", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func onEnterReport(_ sender: Any) {
        SmartTravelPillow.userIdentifier = account.lastUserOrCreateNewOne()
        SmartTravelPillow.presentSDKScenes(from: self, options: [
            .reportIDKey: "3bb208ef28494803aa485977833be0b1",
            .noJumpWhenFailsKey: true
        ])
    }
}
