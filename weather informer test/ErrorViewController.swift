//
//  ErrorViewController.swift
//  weather informer test
//
//  Created by Аркадий Торвальдс on 31.05.2022.
//

import UIKit

class ErrorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        для наглядности устанавливаем цвет фона
        view.backgroundColor = .red
        
//        текстовое поле с информацией о неудачной загрузке данных
        var errorLable = UILabel()
        errorLable.text = "Ошибка загрузки"
        errorLable.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(errorLable)
        errorLable.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalToSuperview().inset(120)
        }
        
        let buttonFirst = UIButton()
        let config1 = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        buttonFirst.setTitle("Попробовать снова", for: .normal)
        buttonFirst.titleLabel?.font = UIFont.systemFont(ofSize: 35)
        buttonFirst.backgroundColor = .gray
        buttonFirst.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        buttonFirst.layer.cornerRadius = 10
        view.addSubview(buttonFirst)
//        при нажатии запускаем функцию tryAgain()
        buttonFirst.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        buttonFirst.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(errorLable).offset(80)
        }
        
    }
    
//    функция просто переводит на контроллер определения погоды
    @objc func tryAgain(sender: UIButton) {
        let controller: UIViewController = WeatherViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
        
    }

}
