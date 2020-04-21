//
//  TestViewController.swift
//  fltbdface
//
//  Created by RandyWei on 2020/4/21.
//

import Foundation

class TestViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        let text = UILabel()
        text.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        text.text = "UILabel"
        self.view.addSubview(text)
        self.view.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 1)
    }
}
