//
//  WeatherViewController.swift
//  Clima v2
//
//  Created by Deonte on 6/17/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var forecastCollectionView: UICollectionView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var temperatueLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var humidityPercentageLabel: UILabel!
    @IBOutlet var weatherIconImage: UIImageView!
    @IBOutlet var todayButton: UIButton!
    @IBOutlet var tomorrowButton: UIButton!
    
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        forecastCollectionView.delegate = self
        forecastCollectionView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    

    @IBAction func searchButtonPressed(_ sender: Any) {
        
    }
    
    //MARK: Networking
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the weather data. \(String(describing: response.data))")
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("There was an error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    

    //MARK: - JSON Parsing
    func updateWeatherData(json: JSON) {
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(((tempResult - 273.15) * 1.8) + 32)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            weatherDataModel.weatherDescription = weatherDataModel.updateWeatherDescription(condition: weatherDataModel.condition)
            weatherDataModel.humidity = json["main"]["humidity"].intValue
            
            updateUIWithWeatherData()
        } else {
            
            cityLabel.text = "Weather Unavailable"
        }
    }
    
    //MARK: - UI Updates
    
    func updateUIWithWeatherData() {
        //cityLabel.text = "\(weatherDataModel.city), Georgia" // Hard coded State information here will make dynamic
        cityLabel.text = placemarkLocation
        temperatueLabel.text = "\(weatherDataModel.temperature)º"
        weatherIconImage.image = UIImage(named: weatherDataModel.weatherIconName)
        descriptionLabel.text = weatherDataModel.weatherDescription
        humidityPercentageLabel.text = "\(weatherDataModel.humidity)%"
    }
    
    // Getting more user readable location info
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the competion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    print("\(placemarks![0])")
                    completionHandler(firstLocation)
                } else {
                    // An error occured during geocoding
                    completionHandler(nil)
                }
            })
        } else {
            // No location was available
            completionHandler(nil)
        }
    }
    
    var placemarkLocation: String = ""
    
    //MARK: - Location Manager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            locationManager.delegate = nil
            
            print("Logitude: \(location.coordinate.longitude) Latitude: \(location.coordinate.latitude)")
            
            let longitude = String(location.coordinate.longitude)
            let latitude = String(location.coordinate.latitude)
            
            let params: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
        
            lookUpCurrentLocation { (placemark) in
                guard let place = placemark else {return}
                self.placemarkLocation = "\(place.locality!), \(place.administrativeArea!)"
            }
            
            getWeatherData(url: CURRENT_WEATHER_URL, parameters: params)
        }
    }
    
    // Handle Location Error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: forecastCell, for: indexPath)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//    
    
}

