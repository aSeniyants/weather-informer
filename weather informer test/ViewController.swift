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
        view.backgroundColor = UIColor(red: 0/255.0, green: 145/255.0, blue: 255/255.0, alpha: 1)
        var helloLable = UILabel()
        helloLable.text = "Информер погоды"
        helloLable.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(helloLable)
        helloLable.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalToSuperview().inset(120)
        }
        
        
        let buttonFirst = UIButton()
        let config1 = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        buttonFirst.setTitle("Запросить данные", for: .normal)
        buttonFirst.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        buttonFirst.backgroundColor = .gray
        buttonFirst.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        buttonFirst.layer.cornerRadius = 10
        view.addSubview(buttonFirst)
        buttonFirst.addTarget(self, action: #selector(printText), for: .touchUpInside)
        buttonFirst.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(helloLable).offset(80)
        }
    }
    
    @objc func printText(sender: UIButton) {
        let controller: UIViewController = WeatherViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
        
    }
    
}

