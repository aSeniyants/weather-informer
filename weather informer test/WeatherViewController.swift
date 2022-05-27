//
//  WeatherViewController.swift
//  weather informer test
//
//  Created by Аркадий Торвальдс on 28.05.2022.
//

import UIKit
import SnapKit

class WeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ok")
        view.backgroundColor = .green
        initalize()
    }
    
    private func initalize() {
        var lable1 = UILabel()
        lable1.text = "hellow 2"
        view.addSubview(lable1)
        lable1.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalToSuperview().inset(150)
        }
    }
    
}
