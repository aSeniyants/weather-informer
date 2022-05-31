//
//  WeatherViewController.swift
//  weather informer test
//
//  Created by Аркадий Торвальдс on 28.05.2022.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
    var weatherToday = UILabel()
    var weatherTomorrow = UILabel()
    let button1 = UIButton()
    var indicator1 = UIActivityIndicatorView()
    var indicator2 = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        print("WVC start")
        
        weatherToday.text = "Погода на сегодня: "
        view.addSubview(weatherToday)
        weatherToday.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalToSuperview().inset(50)
        }
        indicator1.startAnimating()
        indicator1.style = .large
        view.addSubview(indicator1)
        indicator1.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(weatherToday).inset(40)
        }
        
        weatherTomorrow.text = "Погода на завтра: "
        view.addSubview(weatherTomorrow)
        weatherTomorrow.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(weatherToday).inset(100)
        }
        indicator2.startAnimating()
        indicator2.style = .large
        view.addSubview(indicator2)
        indicator2.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(weatherTomorrow).inset(40)
        }
        
        button1.setTitle("button", for: .normal)
        button1.backgroundColor = .gray
        view.addSubview(button1)
        button1.addTarget(self, action: #selector(getData), for: .touchUpInside)
        button1.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(weatherTomorrow).offset(100)
        }
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                self.getDataToday()
                self.getDataTomorrow()
            }
        }
    }
        
    @objc func getData(sender: UIButton) {
        print("hi")
        let request = AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=9&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).cURLDescription { description in
            print(description)
        }.responseJSON { response in
            switch response.result {
            case .success(let value):
                let weatherJSON = JSON(value)
                print("value")
                for elem in weatherJSON["list"].reversed() {
                    let findString = elem.1["dt_txt"].string
                    if ((findString?.contains("12:00:00")) == true) {
                        print("i find")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func getDataToday() {
        print("getDataToday start")
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=1&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).cURLDescription { description in
            print(description)
        }.responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let weatherJSON = JSON(value)
                if weatherJSON["list"][1]["main"].isEmpty  {
                    print("json change")
                    let controller: UIViewController = ErrorViewController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                }
                self.weatherToday.text! = "Погода на сегодня: \(weatherJSON["list"][0]["main"]["temp"])"
                self.indicator1.isHidden = true
                print(weatherToday.text)
            case .failure(let error):
                print(error)
                let controller: UIViewController = ErrorViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
        }
    }
    @objc func getDataTomorrow() {
        print("getDataTomorrow start")
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=9&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).cURLDescription { description in
            print(description)
        }.responseJSON { response in
            switch response.result {
            case .success(let value):
                print("value")
                let weatherJSON = JSON(value)
                self.weatherTomorrow.text! = "Погода на завтра: \(weatherJSON["list"][7]["main"]["temp"])"
                self.indicator2.isHidden = true
            case .failure(let error):
                print(error)
                let controller: UIViewController = ErrorViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
    }
}
}
