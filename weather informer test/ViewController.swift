//
//  ViewController.swift
//  weather informer test
//
//  Created by Аркадий Торвальдс on 27.05.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalize()
        
    }

    private func initalize() {
        view.backgroundColor = .yellow
        var lable1 = UILabel()
        lable1.text = "hellow"
        view.addSubview(lable1)
        lable1.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalToSuperview().inset(150)
        }
        
        let button1 = UIButton()
        button1.setTitle("button", for: .normal)
        button1.backgroundColor = .gray
        view.addSubview(button1)
        button1.addTarget(self, action: #selector(printText), for: .touchUpInside)
        button1.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(lable1).offset(30)
        }
    }
    
    @objc func printText(sender: UIButton) {
        print("hi")
        let controller: UIViewController = WeatherViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
        
    }
    
}

