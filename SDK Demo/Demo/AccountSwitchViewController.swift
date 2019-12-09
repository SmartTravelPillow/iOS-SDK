//
//  AccountSwitchViewController.swift
//  SDK Demo
//
//  Created by BB9z on 2019/11/18.
//  Copyright © 2019 浩雨科技. All rights reserved.
//

import UIKit

/**
 账户切换
 */
class AccountSwitchViewController: UITableViewController {
    var account = AccountManager()
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        items = account.historyUserIDList
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let uid = items[indexPath.row]
        cell.textLabel?.text = uid
        cell.accessoryType = uid == account.userID ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        account.userID = items[indexPath.row]
        navigationController?.popViewController(animated: true)
    }

    @IBAction func onAdd(_ sender: Any) {
        account.userID = account.createNewUserID()
        navigationController?.popViewController(animated: true)
    }
}
