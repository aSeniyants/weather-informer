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

//основной контроллер, где запрашивается информация
class WeatherViewController: UIViewController {
    
//    задаем текст с погодой на сегодня
    var weatherToday = UILabel()
//    текстовое поля для отображения погоды на завтра
    var weatherTomorrow = UILabel()
//    кнопка отправки погоды ("поделиться")
    let shareButton = UIButton()
//    кнопка обновления погоды
    let refreshButton = UIButton()
//    индикаторы для наглядности загрузки данных
    var indicator1 = UIActivityIndicatorView()
    var indicator2 = UIActivityIndicatorView()
//    конфигурация символов SF Symbols для более наглядного отображения
    let shareSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 35, weight: .black)
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        для удобства работы и наглядности устанавливаем цвет контроллера
        view.backgroundColor = .green
        
//        по порядку идут элементы, предназначение которых указано выше
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
//        при нажатии на кнопку обновления перезапускается функция refreshData() для обновления данных о погоде
        refreshButton.addTarget(self, action: #selector(refreshData), for: .touchUpInside)
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
//        при нажатии на кнопку Share запускается функция shareWeather()
        shareButton.addTarget(self, action: #selector(shareWeather), for: .touchUpInside)
        shareButton.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.top.equalTo(refreshButton).offset(70)
        }
        
//        в связи с тем что в ТЗ указана загрузка погоды поочередности, необходимо запускать
//        функцию получения погоды на сегодя и на завтра по очереди.
//        Для этого необходимо использовать sync, но для защиты от блокирования приложения на время
//        выполнения функции необходимо их выделить в отдельный поток через async
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                self.getDataToday()
                self.getDataTomorrow()
            }
        }
    }
    
//    функция обновляет погоду на экране. На первый взгляд обновление происходит
//    значительно быстрее чем первый раз, возникает ощущение что данные не загружаются с сервера,
//    но если отключить на телефоне интернет, то подгрузка данных происходит только после включения.
    @objc func refreshData(sender: UIButton) {
//        приводим экран в начальное состояние - запускаем индикаторы, обнуляем текст
        self.indicator1.startAnimating()
        self.indicator1.isHidden = false
        self.weatherToday.text = "Погода на сегодня: "
        self.indicator2.startAnimating()
        self.indicator2.isHidden = false
        self.weatherTomorrow.text = "Погода на завтра: "
//        в отдельном потоке запускаем поочередну загрузку данных
        DispatchQueue.global().async {
            DispatchQueue.global().sync {
                self.getDataToday()
                self.getDataTomorrow()
            }
        }
    }
    
//    функция, которая запускается при нажатии кнопки "Поделиться".
//    При первом запуске системное окно открывается необычно долго... Причина не ясна..
//    при запуске открывается алерт из двух кнопок.
//    При нажатии на соответствующую кнопку штатными функциями ОС можно поделиться информацией на день.
    @objc func shareWeather(sender: UIButton) {
//        создаем алерт из двух кнопок
        let actionSheet = UIAlertController()
//        кнопка отправки погоды на сегодня
        let todayAction = UIAlertAction(title : "Отправить прогноз на сегодня" , style : .default){
                (action) in
            print("send today")
            let items = [self.weatherToday.text!]
            let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)}
//        кнопка отправки погоды на завтра
        let tomorrowAction = UIAlertAction(title : "Отправить прогноз на завтра" , style : .default){
                (action) in
            let items = [self.weatherTomorrow.text!]
            let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(avc, animated: true, completion: nil)}
//        добавляем кнопки в алерт
        actionSheet.addAction(todayAction)
        actionSheet.addAction(tomorrowAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
//    Функция получения погоды на сегодня.
    @objc func getDataToday() {
//        направляем запрос на сервер, получаем JSON данные
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=1&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).responseJSON { [self] response in
//            делаем проверку выполнения запроса: получены данные или ошибка
            switch response.result {
            case .success(let value):
//                если приходят данные, то сохраняем их в json
                let weatherJSON = JSON(value)
//                считаю что нужно провести дополнительную проверку... Можно обработать код запроса по номеру,
//                но в случае если начнутся неполадки на стороне сервера, или изменится конфигурация json файла,
//                то код запроса будет удовлетворительный, но данных мы все равно не получим.
//                Данная конструкция if позволяет понять, есть ли необходимые нам данные.
//                В случае отсутствия - пишем об ошибке загрузки, но на контроллер ошибки не идем, пробуем подгрузить погоду на завтра.
                if weatherJSON["list"][0]["main"].isEmpty == true {
                    self.weatherToday.text! = "Ошибка загрузки!"
                    self.indicator1.isHidden = true
                } else {
//                если необходимые нам данные пришли и обработаны, обновляем текст лейбла с погодой на сегодня
                    self.weatherToday.text! = "Погода на сегодня: \(weatherJSON["list"][0]["main"]["temp"])"
//                скрываем индикатор загрузки
                    self.indicator1.isHidden = true
                }
            case .failure(_):
//                в случае если соединения с сервером нет, или приходит ошибка, выдаем ошибку,
//                но на контроллер с ошибкой так же не идем
                self.weatherToday.text! = "Ошибка загрузки!"
//                скрываем индикатор
                self.indicator1.isHidden = true
            }
        }
    }
    
//    функция получения погоды на завтра
    @objc func getDataTomorrow() {
//        в связи с тем, что сервер openweathermap.org в бесплатном тарифе дает только данные на 5 дней и разбивает их
//        на три часа (дневной прогноз день/ночь получить нельзя), а оплатить сервис картами России не представляется возможным,
//        мы запрашиваем 9 таких прогнозов (на 3 часа), чтобы узнать погоду через 24 часа (параметр cnt=9 в запросе)
        AF.request("https://api.openweathermap.org/data/2.5/forecast?id=473247&units=metric&lang=ru_RU&cnt=9&appid=df28b4bb219760ba8454f3b4a4fc5f2e", method: .get).responseJSON { response in
            switch response.result {
            case .success(let value):
//                так же проверяем полученные данные, если все успешно, получаем JSON
                let weatherJSON = JSON(value)
//                по аналогии проверяем валидность данных, в случае отсутствия - идем на контроллер с ошибкой
                if weatherJSON["list"][7]["main"].isEmpty == true {
//                    в случае ошибки идем на контроллер с ошибкой
                    let controller: UIViewController = ErrorViewController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true)
                } else {
//                в случае если json верно распарсился, указываем погоду на завтра
                self.weatherTomorrow.text! = "Погода на завтра: \(weatherJSON["list"][7]["main"]["temp"])"
//                убираем индикатор
                self.indicator2.isHidden = true
                        }
            case .failure(_):
//                в случае получения ошибки (можно проверить путем изменения ссылки в запросе) идем на контроллер с ошибкой
                let controller: UIViewController = ErrorViewController()
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }
    }
}
}
