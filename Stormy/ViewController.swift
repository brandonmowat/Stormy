//
//  ViewController.swift
//  Overcast
//
//  Created by Brandon Mowat on 2015-02-17.
//  Copyright (c) 2015 Brandon Mowat. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var realTemp: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButt: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var day2Label: UILabel!
    @IBOutlet weak var day2Icon: UIImageView!
    @IBOutlet weak var day2Temp: UILabel!
    @IBOutlet weak var day2Precip: UILabel!
    
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day3Icon: UIImageView!
    @IBOutlet weak var day3Temp: UILabel!
    @IBOutlet weak var day3Precip: UILabel!
    
    @IBOutlet weak var day4Label: UILabel!
    @IBOutlet weak var day4Icon: UIImageView!
    @IBOutlet weak var day4Temp: UILabel!
    @IBOutlet weak var day4Precip: UILabel!
    
    @IBOutlet weak var day5Label: UILabel!
    @IBOutlet weak var day5Icon: UIImageView!
    @IBOutlet weak var day5Temp: UILabel!
    @IBOutlet weak var day5Precip: UILabel!
    
    @IBOutlet weak var day6Label: UILabel!
    @IBOutlet weak var day6Icon: UIImageView!
    @IBOutlet weak var day6Temp: UILabel!
    @IBOutlet weak var day6Precip: UILabel!
    
    
    
    @IBOutlet weak var todaySummary: UILabel!
    
    
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var locationManager: CLLocationManager!
    var userLocation : String!
    var userLatitude : Double!
    var userLongitude : Double!
    var sunsetTime: Int = 15
    
    private let apiKey = "151d781924566285d4b596a01f8c0ca0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        
        self.locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        //refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
        
    }
    
    //Location Code
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
            
            self.userLatitude = coord.latitude
            self.userLongitude = coord.longitude
            println(userLatitude)
            println(userLongitude)
            
            getCurrentWeatherData()
            
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
                shouldIAllow = true
            }
            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
            if (shouldIAllow == true) {
                NSLog("Location to Allowed")
                // Start location services
                locationManager.startUpdatingLocation()
            } else {
                NSLog("Denied access: \(locationStatus)")
            }
    }
    

    // Get TimeStamp
    func getTimeStamp() ->Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour, fromDate: date)
        let hour = components.hour
        
        return hour
    }
    
    
    func getCurrentWeatherData() -> Void {
        
        let baseURL = NSURL(string:"https://api.forecast.io/forecast/\(apiKey)/")
        
        let forecastURL = NSURL(string: "\(userLatitude),\(userLongitude)", relativeToURL: baseURL)
        // Do any additional setup after loading the view, typically from a nib.
        
        println(forecastURL)
        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //self.temperatureLabel.text = "\(currentWeather.realTemp)"
                    //self.realTemp.text = "\(currentWeather.temperature) C"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "\(currentWeather.currentDate)"
                    //self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "It's \(currentWeather.summary) & \(currentWeather.realTemp)"
                    //self.city.text = "Hello"
                    self.sunsetTime = currentWeather.sunsetTime
                    
                    // Today Summary
                    self.todaySummary.text = currentWeather.todaySummary
                    
                    // Day 2
                    self.day2Icon.image = currentWeather.day2Icon!
                    self.day2Label.text = "\(currentWeather.tomorrowDate)"
                    self.day2Temp.text = "\(currentWeather.day2temp)"
                    self.day2Precip.text = "\(currentWeather.day2Precip)%"
                    println(currentWeather.tomorrowDate)
                    
                    // Day 3
                    self.day3Icon.image = currentWeather.day3Icon!
                    self.day3Label.text = "\(currentWeather.day3Date)"
                    self.day3Temp.text = "\(currentWeather.day3Temp)"
                    self.day3Precip.text = "\(currentWeather.day3Precip)%"
                    
                    // Day 4
                    self.day4Icon.image = currentWeather.day4Icon!
                    self.day4Label.text = "\(currentWeather.day4Date)"
                    self.day4Temp.text = "\(currentWeather.day4Temp)"
                    self.day4Precip.text = "\(currentWeather.day4Precip)%"
                    
                    // Day 5
                    self.day5Icon.image = currentWeather.day5Icon!
                    self.day5Label.text = "\(currentWeather.day5Date)"
                    self.day5Temp.text = "\(currentWeather.day5Temp)"
                    self.day5Precip.text = "\(currentWeather.day5Precip)%"
                    
                    // Day 6
                    self.day6Icon.image = currentWeather.day6Icon!
                    self.day6Label.text = "\(currentWeather.day6Date)"
                    self.day6Temp.text = "\(currentWeather.day6Temp)"
                    self.day6Precip.text = "\(currentWeather.day6Precip)%"
                    
                    //stop refresh
                    //self.refreshActivityIndicator.stopAnimating()
                    //self.refreshActivityIndicator.hidden = true
                    //self.self.refreshButt.hidden = false
                })
                
            }
            
        })
        downloadTask.resume()
        
    }
    
    var timer: dispatch_source_t?
    
    func startTimer() {
        let queue = dispatch_queue_create("com.domain.app.timer", nil)
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 120 * NSEC_PER_SEC, 1 * NSEC_PER_SEC); // every 60 seconds, with leeway of 1 second
        dispatch_source_set_event_handler(timer) {
            self.getCurrentWeatherData()
            var theHour = self.getTimeStamp()
        }
        dispatch_resume(timer)
    }
    
    func stopTimer() {
        dispatch_source_cancel(timer)
        timer = nil
    }

    @IBAction func refrsher() {
        refreshButt.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
        getCurrentWeatherData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

