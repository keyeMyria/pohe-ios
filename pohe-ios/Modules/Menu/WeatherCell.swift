//
//  WeatherCell.swift
//  pohe-ios
//
//  Created by 石燕慧 on 2018/07/25.
//  Copyright © 2018年 石 臙慧. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import APIKit

protocol WeatherCellDelegate: class {
    
    /// 天気情報更新完了
    ///
    /// - Parameters:
    ///   - cell: 呼び出し元
    ///   - result: 取得結果
    func updateFinished(cell: WeatherCell, result: Bool)
    //
    //    /// 位置情報使用許可アラートを表示する
    //    ///
    //    /// - Parameter cell: 呼び出し元
    //    func showAlertAuthorizationLocation(cell: EtcWeatherCell)
}

class WeatherCell: UITableViewCell, CLLocationManagerDelegate {
    @IBOutlet weak var wea: UILabel!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var today: UILabel!
    
    @IBOutlet weak var tempo: UILabel!
    
    weak var delegate: WeatherCellDelegate?
    private let session = Session.shared
    private let bag = DisposeBag()
    static let cellID = "WeatherCell"
    /// ロケーション
    let locationManager = CLLocationManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationManager.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // 起動時のみ、位置情報の取得が許可
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        // 天気情報更新
        update(location: location)
        
    }
    
    func updateWeather() {
        let a = CLLocationManager.authorizationStatus()
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // まだユーザに許可を求めていない。
            locationManager.requestWhenInUseAuthorization()
            update()
        case .denied, .restricted:
            if CLLocationManager.locationServicesEnabled() {
                // 位置情報サービスはオンにしているが、自分のアプリには許可していない。
                //                delegate?.showAlertAuthorizationLocation(cell: self)
                print("not allow location service")
            }
            update()
        default: break
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func update(location: CLLocation = CLLocation(latitude: 35.709026, longitude: 139.731993)) {
        print(location)
        setWeather(location: location)
        setLocation(location: location)
    }
    
    func setWeather(location: CLLocation) {
        let request = RestAPI.GetWeatherRequest(lat: location.coordinate.latitude.description, lon: location.coordinate.longitude.description)
        session.rx.response(request: request).share()
            .subscribe(
                onNext: { [weak self] (weather: Weather) in
                    self?.wea.text = WeatherModel.shared.iconImage(id: weather.weather[0].icon)! + String.makeTemp(temp: weather.main.temp)
                    self?.tempo.text = "\(String.makeTemp(temp: weather.main.temp_min))\n\(String.makeTemp(temp: weather.main.temp_max))"
                    self?.delegate?.updateFinished(cell: self!, result: true)
                }
            )
            .disposed(by: bag)
    }
    
    func setLocation(location: CLLocation) {
        let request = RestAPI.GetLocationRequest(x: location.coordinate.longitude.description, y: location.coordinate.latitude.description)
        session.rx.response(request: request).share()
            .subscribe(
                onNext: { [weak self] (loc: Location) in
                    let res = loc.response.location[0]
                    self?.location.text = "\(res.city) \(res.town)\n"
                    self?.today.text = Date.stringFromDate(date: Date(), format: "yyyy-MM-dd")
//                    self?.delegate?.updateFinished(cell: self!, result: true)
                }
            )
            .disposed(by: bag)
    }
    
    func configure(entity: Menu) {
        
//        location.text = entity.name

        if entity.subLabelType == "weather" {
            updateWeather()
        }
    }
    
}
