//
//  Current.swift
//  Overcast
//
//  Created by Brandon Mowat on 2015-02-17.
//  Copyright (c) 2015 Brandon Mowat. All rights reserved.
//

import Foundation
import UIKit

struct Current {
    var currentTime: String?
    var sunsetTime: Int
    var currentDate: String
    var temperature: Int
    var realTemp: Int
    var precipProbability: Double
    var summary: String
    var todaySummary: String
    var icon: UIImage?
    var day2temp: Int
    var tomorrowDate: String
    var day2Icon: UIImage?
    var day2Precip: Int
    
    var day3Date: String
    var day3Icon: UIImage?
    var day3Temp: Int
    var day3Precip: Int
    
    var day4Date: String
    var day4Icon: UIImage?
    var day4Temp: Int
    var day4Precip: Int
    
    var day5Date: String
    var day5Icon: UIImage?
    var day5Temp: Int
    var day5Precip: Int
    
    var day6Date: String
    var day6Icon: UIImage?
    var day6Temp: Int
    var day6Precip: Int
    
    init(weatherDictionary: NSDictionary) {
        var currentWeatherDictionary: NSDictionary = weatherDictionary["currently"] as NSDictionary
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
        let day5: NSDictionary = dailyData[4] as NSDictionary
        println(tomorrow)
        let day6: NSDictionary = dailyData[5] as NSDictionary
        println(tomorrow)
        
        todaySummary = "Still thinking..."
        currentDate = "Calling date gods"
        sunsetTime = 0
        day2temp = 0
        day2Precip = 0
        day3Temp = 0
        day3Precip = 0
        day4Temp = 0
        day4Precip = 0
        day5Temp = 0
        day5Precip = 0
        day6Temp = 0
        day6Precip = 0
        tomorrowDate = "?"
        day3Date = "?"
        day4Date = "?"
        day5Date = "?"
        day6Date = "?"
        
        // day 2 temp
        var tomorrowTempMax = tomorrow["temperatureMax"] as Int
        var tomorrowTempMin = tomorrow["temperatureMin"] as Int
        day2temp = Int((tomorrowTempMax+tomorrowTempMin)/2) as Int
        var day2Precipitation = tomorrow["precipProbability"] as Double
        day2Precip = Int(day2Precipitation*100)
        
        // day 3 temp
        var day3max = day3["temperatureMax"] as Int
        var day3min = day3["temperatureMin"] as Int
        day3Temp = Int((day3max+day3min)/2) as Int
        var day3Precipitation = day3["precipProbability"] as Double
        day3Precip = Int(day3Precipitation*100)
        
        // day 4 temp
        var day4max = day4["temperatureMax"] as Int
        var day4min = day4["temperatureMin"] as Int
        day4Temp = Int((day4max+day4min)/2) as Int
        var day4Precipitation = day4["precipProbability"] as Double
        day4Precip = Int(day4Precipitation*100)
        
        // day 5 temp
        var day5max = day5["temperatureMax"] as Int
        var day5min = day5["temperatureMin"] as Int
        day5Temp = Int((day5max+day5min)/2) as Int
        var day5Precipitation = day5["precipProbability"] as Double
        day5Precip = Int(day5Precipitation*100)
        
        // day 4 temp
        var day6max = day6["temperatureMax"] as Int
        var day6min = day6["temperatureMin"] as Int
        day6Temp = Int((day6max+day6min)/2) as Int
        day6Precip = day6["precipProbability"] as Int
        var day6Precipitation = day6["precipProbability"] as Double
        day6Precip = Int(day6Precipitation*100)
        
        temperature = currentWeatherDictionary["apparentTemperature"] as Int
        realTemp = currentWeatherDictionary["temperature"] as Int
        precipProbability = currentWeatherDictionary["precipProbability"] as Double
        summary = currentWeatherDictionary["summary"] as String
        
        // Modify/Optimize summary here
        switch summary {
        case "Rain":
            summary = "rainy"
        case "Clear":
            summary = "clear"
        case "Snow":
            summary = "snowy"
        case "Fog":
            summary = "foggy"
        case "Drizzle":
            summary = "drizzly"
        default:
            break
        }
        
        let currentTimeIntVal = currentWeatherDictionary["time"] as Int
        currentTime = dateStringFormatUnixTime(currentTimeIntVal)
        currentDate = fullDate(currentTimeIntVal)
        sunsetTime = dateStringFormatUnixTimeHour(currentTimeIntVal)
        
        let iconString = currentWeatherDictionary["icon"] as String
        icon = weatherIconFromString(iconString)
        
        temperature = convertToCelsius(self.temperature)
        realTemp = convertToCelsius(self.realTemp)
        
        todaySummary = today["summary"] as String
        
        // Tomorrow Weather
        day2temp = convertToCelsius(self.day2temp)
        let tomorrowDay = tomorrow["time"] as Int
        tomorrowDate = dateStringFormatUnixTimeDay(tomorrowDay)
        let day2IconString = tomorrow["icon"] as String
        day2Icon = weatherIconFromString(day2IconString)
        
        // Day 3 Weather
        day3Temp = convertToCelsius(self.day3Temp)
        let day3Day = day3["time"] as Int
        day3Date = dateStringFormatUnixTimeDay(day3Day)
        let day3IconString = day3["icon"] as String
        day3Icon = weatherIconFromString(day3IconString)
        
        // Day 4 Weather
        day4Temp = convertToCelsius(self.day4Temp)
        let day4Day = day4["time"] as Int
        day4Date = dateStringFormatUnixTimeDay(day4Day)
        let day4IconString = day4["icon"] as String
        day4Icon = weatherIconFromString(day4IconString)
        
        // Day 5 Weather
        day5Temp = convertToCelsius(self.day5Temp)
        let day5Day = day5["time"] as Int
        day5Date = dateStringFormatUnixTimeDay(day5Day)
        let day5IconString = day5["icon"] as String
        day5Icon = weatherIconFromString(day5IconString)
        
        // Day 6 Weather
        day6Temp = convertToCelsius(self.day6Temp)
        let day6Day = day6["time"] as Int
        day6Date = dateStringFormatUnixTimeDay(day6Day)
        let day6IconString = day6["icon"] as String
        day6Icon = weatherIconFromString(day6IconString)
       
        println(day2temp)
    }
    
    func dateStringFormatUnixTime(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func dateStringFormatUnixTimeHour(unixTime: Int) -> Int {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h"
        return dateFormatter.stringFromDate(weatherDate).toInt()!
    }
    
    func dateStringFormatUnixTimeDay(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func dateStringFormatUnixTimeDayOfMonth(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func dateStringFormatUnixTimeDayFull(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func dateStringFormatUnixTimeMonth(unixTime: Int) -> String {
        let timeInSeconds = NSTimeInterval(unixTime)
        let weatherDate = NSDate(timeIntervalSince1970: timeInSeconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.stringFromDate(weatherDate)
    }
    
    func fullDate(unixTime: Int) ->String {
        var dayofmonth = dateStringFormatUnixTimeDayOfMonth(unixTime)
        var dayofweek = dateStringFormatUnixTimeDayFull(unixTime)
        var month = dateStringFormatUnixTimeMonth(unixTime)
        return "\(dayofweek), \(month) \(dayofmonth)"
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