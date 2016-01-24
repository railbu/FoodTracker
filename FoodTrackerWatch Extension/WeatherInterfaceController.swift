//
//  WeatherInterfaceController.swift
//  FoodTracker
//
//  Created by rail bu on 15/12/4.
//  Copyright © 2015年 Rail Bu. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire

class WeatherInterfaceController: WKInterfaceController {
    
    // MARK: Properties
    @IBOutlet var weatherLabel: WKInterfaceLabel!
    @IBOutlet var background: WKInterfaceGroup!
    @IBOutlet var cityLabel: WKInterfaceLabel!
    
    var cityName = "北京"

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let name = context as? String {
            self.cityName = name
        }
        
        let url = "http://api.map.baidu.com/telematics/v3/weather"
        
        Alamofire.request(.GET, url, parameters: ["location": cityName, "output": "json", "ak": "n7qohMMMOQmRMPwinqpTyr3t" ])
            .responseJSON(options: NSJSONReadingOptions.MutableContainers)
                { response in
                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let data = response.result.value {
                    var info:[JSON] = JSON(data)["results"].array!
                    let weather_data = info[0]["weather_data"]
                    let weather = weather_data[0]["weather"]
                    let temperature = weather_data[0]["temperature"]
                    
                    print("weather: \(weather)")
                    
                    self.weatherLabel.setText(" \(weather) \(temperature)")
                    self.cityLabel.setText(self.cityName)
                    self.background.setBackgroundImageNamed("\(weather)w")
                    
                }
        }

        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: Action
    @IBAction func cityPicker() {
        pushControllerWithName("CityPickerInterface", context: cityName)
    }

    

}
