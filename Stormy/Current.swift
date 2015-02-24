//
//  Current.swift
//  Stormy
//
//  Created by Brandon Mowat on 2015-02-17.
//  Copyright (c) 2015 Brandon Mowat. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var currentTime: String?
    var temperature: Int
    var realTemp: Int
    var precipProbability: Double
    var summary: String
    var todaySummary: String
    var icon: UIImage?
    var tomorrowTempMax: Int
    var tomorrowTempMin: Int
    var tomorrowTempAvg: Int
    var tomorrowDate: String
    var day2Icon: UIImage?
    var day3Date: String
    var day3Icon: UIImage?
    var day4Date: String
    var day4Icon: UIImage?
    
    init(weatherDictionary: NSDictionary) {
        let currentWeatherDictionary: NSDictionary = weatherDictionary["currently"] as NSDictionary
        println(weatherDictionary)
        let dailyWeather = weatherDictionary["daily"] as NSDictionary
        let dailyData = dailyWeather["data"] as NSArray
        
        let today: NSDictionary = dailyData[0] as NSDictionary
        let tomorrow: NSDictionary = dailyData[1] as NSDictionary
        println(tomorrow)
        let day3: NSDictionary = dailyData[2] as NSDictionary
        println(tomorrow)
        let day4: NSDictionary = dailyData[3] as NSDictionary
        println(tomorrow)
        
        todaySummary = "Still thinking..."
        tomorrowTempAvg = 0
        tomorrowDate = "?"
        day3Date = "?"
        day4Date = "?"
        tomorrowTempMax = tomorrow["temperatureMax"] as Int
        tomorrowTempMin = tomorrow["temperatureMin"] as Int
        
        temperature = currentWeatherDictionary["apparentTemperature"] as Int
        realTemp = currentWeatherDictionary["temperature"] as Int
        precipProbability = currentWeatherDictionary["precipProbability"] as Double
        summary = currentWeatherDictionary["summary"] as String
        
        let currentTimeIntVal = currentWeatherDictionary["time"] as Int
        currentTime = dateStringFormatUnixTime(currentTimeIntVal)
        
        let iconString = currentWeatherDictionary["icon"] as String
        icon = weatherIconFromString(iconString)
        
        temperature = convertToCelsius(self.temperature)
        realTemp = convertToCelsius(self.realTemp)
        
        todaySummary = today["summary"] as String
        
        // Tomorrow Weather
        tomorrowTempMax = convertToCelsius(self.tomorrowTempMax)
        tomorrowTempMin = convertToCelsius(self.tomorrowTempMin)
        tomorrowTempAvg = Int((tomorrowTempMax+tomorrowTempMin)/2) as Int
        let tomorrowDay = tomorrow["time"] as Int
        tomorrowDate = dateStringFormatUnixTimeDay(tomorrowDay)
        let day2IconString = tomorrow["icon"] as String
        day2Icon = weatherIconFromString(day2IconString)
        
        // Day 3 Weather
        let day3Day = day3["time"] as Int
        day3Date = dateStringFormatUnixTimeDay(day3Day)
        let day3IconString = day3["icon"] as String
        day3Icon = weatherIconFromString(day3IconString)
        
        // Day 4 Weather
        let day4Day = day4["time"] as Int
        day4Date = dateStringFormatUnixTimeDay(day4Day)
        let day4IconString = day4["icon"] as String
        day4Icon = weatherIconFromString(day4IconString)
       
        println(tomorrowTempAvg)
    }
    
    func dateStringFormatUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func dateStringFormatUnixTimeDay(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
    
    func weatherIconFromString(stringIcon: String) -> UIImage {
        var imageName: String
        
        switch stringIcon {
        case "clear-day":
            imageName = "clear-day"
        case "clear-night":
            imageName = "clear-night"
        case "rain":
            imageName = "rain"
        case "snow":
            imageName = "snow"
        case "sleet":
            imageName = "sleet"
        case "thunderstorm":
            imageName = "thunderstorm"
        case "wind":
            imageName = "wind"
        case "fog":
            imageName = "fog"
        case "cloudy":
            imageName = "cloudy"
        case "partly-cloudy-day":
            imageName = "partly-cloudy"
        case "partly-cloudy-night":
            imageName = "cloudy-night"
        default:
            imageName = "default"
        }
        var iconName = UIImage(named: imageName)
        return iconName!
    }
}