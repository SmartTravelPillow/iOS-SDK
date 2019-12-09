//
//  AppearanceCustomVCs.swift
//  SDK Demo
//
//  Created by BB9z on 2019/11/18.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

import SmartTravelPillow

/**
 自定义主题色
 */
class CustomTintViewController: UIViewController {

    @IBOutlet weak var colorPicker: HRColorPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        colorPicker.color = UIApplication.shared.keyWindow?.tintColor
    }

    @IBAction func onDone(_ sender: Any) {
        view.window?.tintColor = colorPicker.color
        navigationController?.popViewController(animated: true)
    }
}

/**
 自定义导航样式
 */
class CustomNavigationStyleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundColorPicker.color = SmartTravelPillow.navigationBarBackgroundColor ?? UIColor.darkGray
        itemColorPicker.color = SmartTravelPillow.navigationBarItemColor ?? UIColor.white
        statusBarStyleSwitch.isOn = (SmartTravelPillow.statusBarStyle == .lightContent)
    }

    @IBOutlet weak var backgroundColorPicker: HRColorPickerView!

    @IBOutlet weak var itemColorPicker: HRColorPickerView!

    @IBOutlet weak var statusBarStyleSwitch: UISwitch!

    @IBAction func onDone(_ sender: Any) {
        SmartTravelPillow.navigationBarBackgroundColor = backgroundColorPicker.color
        SmartTravelPillow.navigationBarItemColor = itemColorPicker.color
        if statusBarStyleSwitch.isOn {
            SmartTravelPillow.statusBarStyle = .lightContent
        }
        else {
            if #available(iOS 13.0, *) {
                SmartTravelPillow.statusBarStyle = .darkContent
            } else {
                SmartTravelPillow.statusBarStyle = .default
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
