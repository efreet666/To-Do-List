//
//  ViewController.swift
//  HomeWork 12.1
//
//  Created by Влад Бокин on 12.03.2021.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    @IBOutlet var table: UITableView!
     
    var models = [Daily]()

    var current: Current?
    var currentWeather: [Current]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func AlamofireRequest(){
            let request = AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&appid=e9d627b7a7c7b7709e1036236dc6da8f")
                request.responseJSON { (data) in
//                  print(data)
                }
            AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&appid=e9d627b7a7c7b7709e1036236dc6da8f")
              .validate()
              .responseDecodable(of: weatherResponse.self) { (response) in
                guard let weather = response.value else { return }
              print(weather)
                print(weather.current!)
              }
        }

        AlamofireRequest()

        
        table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=55.7522&lon=37.6156&lang=ru&appid=e9d627b7a7c7b7709e1036236dc6da8f"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            //validation
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
           
            //convert data to models
            
            var json: weatherResponse?
            do{
                json = try JSONDecoder().decode(weatherResponse.self, from: data)
            }
            catch{
                print("error: \(error)")
            }
            guard let result = json else{
            return
            }
            
            let entries = result.daily
            
            self.models.append(contentsOf: entries!)
            
            let current = result.current
            self.current = current
        
            
            //update user inteface
            DispatchQueue.main.async {
                self.table.reloadData()
                self.table.tableHeaderView = self.createTableHeader()
            }
        }) .resume()
        
        
        

           
    }
    
    func createTableHeader() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width ))
        headerView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        let locationLabel = UILabel(frame: CGRect(x: 5, y: 0 , width: view.frame.size.width -  20, height: headerView.frame.size.width/5 ))
        let weatherLabel = UILabel(frame: CGRect(x: 10, y: 40 + locationLabel.frame.size.height, width: view.frame.size.width -  20, height: headerView.frame.size.width/5 ))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + weatherLabel.frame.size.height  , width: view.frame.size.width -  20, height: headerView.frame.size.width/2 ))
        
        headerView.addSubview(locationLabel)
        headerView.addSubview(weatherLabel)
        headerView.addSubview(tempLabel)
        
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        tempLabel.textAlignment = .center
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 35)
        weatherLabel.textAlignment = .center
        weatherLabel.font = UIFont(name: "Helvetica", size: 25)
        tempLabel.text = "\((Int((self.current?.temp)!)) - 271)°"
        
        locationLabel.text = "Moscow"
        weatherLabel.text = "Сloudly" //не разобрался как правильно вывести текущее состояние погоды
        return headerView
    }
    
    
    //table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



//MARK: - DATA MODEL
//
//
//
// MARK: - Weather
struct weatherResponse: Codable {
    let lat, lon: Double
    let timezone: String?
    let timezoneOffset: Int?
    let current: Current?
    let minutely: [Minutely]?
    let hourly: [Current]?
    let daily: [Daily]?
    let alerts: [Alert]?

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset
        case current, minutely, hourly, daily, alerts
    }
}

// MARK: - Alert
struct Alert: Codable {
    let senderName, event: String?
    let start, end: Int?
    let alertDescription: String?

    enum CodingKeys: String, CodingKey {
        case senderName
        case event, start, end
        case alertDescription
    }
}

// MARK: - Current
struct Current: Codable {
    let dt: Int?
    let sunrise, sunset: Int?
    let temp, feelsLike: Double?
    let pressure, humidity: Int?
    let dewPoint, uvi: Double?
    let clouds, visibility: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [WeatherElement]?
    let snow: Snow?
    let windGust, pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case uvi, clouds, visibility
        case windSpeed
        case windDeg
        case weather, snow
        case windGust
        case pop
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H
    }
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int?
    let main: Main
    let weatherDescription: Description?
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription
        case icon
    }
}
enum Icon: String, Codable {
    case the01D = "01d"
    case the01N = "01n"
    case the02D = "02d"
    case the03D = "03d"
    case the04D = "04d"
    case the10D = "10d"
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case snow = "Snow"
    case rain = "Rain"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightSnow = "light snow"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    case snow = "snow"
    case moderateRain = "moderate rain"
}

// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset: Int?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure, humidity: Int?
    let dewPoint, windSpeed: Double?
    let windDeg: Int?
    let weather: [WeatherElement]
    let clouds: Int?
    let pop: Double?
    let snow: Double?
    let uvi: Double?
    let rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike
        case pressure, humidity
        case dewPoint
        case windSpeed
        case windDeg
        case weather, clouds, pop, snow, uvi, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double?
    let eve, morn: Double?
}

// MARK: - Minutely
struct Minutely: Codable {
    let dt: Int
    let precipitation: Double
}
