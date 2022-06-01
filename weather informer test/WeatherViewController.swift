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
    let shareButton = UIButton()
    let refreshButton = UIButton()
    var indicator1 = UIActivityIndicatorView()
    var indicator2 = UIActivityIndicatorView()
    let shareSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 35, weight: .black)
    

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
        
        refreshButton.setTitle("Попробовать снова", for: .normal)
        refreshButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        refreshButton.backgroundColor = .gray
        refreshButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        refreshButton.layer.cornerRadius = 10
        view.addSubview(refreshButton)
        refreshButton.addTarget(self, action: #selector(viewDidLoad), for: .touchUpInside)
        refreshButton.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(weatherTomorrow).offset(80)
        }
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up.fill", withConfiguration: shareSymbolConfiguration), for: .normal)
        shareButton.backgroundColor = .gray
        shareButton.contentEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        shareButton.layer.cornerRadius = 10
        shareButton.tintColor = UIColor.white
        view.addSubview(shareButton)
        shareButton.addTarget(self, action: #selector(shareWeather), for: .touchUpInside)
        shareButton.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(refreshButton).offset(70)
        }
        
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                self.getDataToday()
                self.getDataTomorrow()
            }
        }
    }
        
    @objc func refreshData(sender: UIButton) {
        print("refresh data")
        self.indicator1.startAnimating()
        self.indicator2.startAnimating()
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                self.getDataToday()
                self.getDataTomorrow()
            }
        }
    }
    
    @objc func shareWeather(sender: UIButton) {
        print("share")
        let actionSheet = UIAlertController()
        let todayAction = UIAlertAction(title : "Отправить прогноз на сегодня" , style : .default){
                (action) in
            print("send today")
            let items = [self.weatherToday.text!]
            let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)}
        let tomorrowAction = UIAlertAction(title : "Отправить прогноз на завтра" , style : .default){
                (action) in
            let items = [self.weatherTomorrow.text!]
            let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)
              print("tomorrow")
           }
        actionSheet.addAction(todayAction)
        actionSheet.addAction(tomorrowAction)
        self.present(actionSheet, animated: true, completion: nil)
        
//        let items = [weatherToday.text!, weatherTomorrow.text!]
//        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        self.present(avc, animated: true, completion: nil)
    }
    
    @objc func getDataToday() {
        print("getDataToday start")
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=1&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                var weatherJSON = JSON(value)
                if weatherJSON["list"][0]["main"].isEmpty  {
                    print("json change")
                    let controller: UIViewController = ErrorViewController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                }
                self.weatherToday.text! = "Погода на сегодня: \(weatherJSON["list"][0]["main"]["temp"])"
                self.indicator1.isHidden = true
            case .failure(let error):
                print(error)
                self.weatherToday.text! = "Ошибка загрузки!"
                self.indicator1.isHidden = true
            }
        }
    }
    @objc func getDataTomorrow() {
        print("getDataTomorrow start")
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=9&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("value")
                let weatherJSON = JSON(value)
                if weatherJSON["list"][7]["main"].isEmpty  {
                    print("json change")
                    let controller: UIViewController = ErrorViewController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                }
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
