//
//  CityPickerInterfaceController.swift
//  FoodTracker
//
//  Created by rail bu on 15/12/4.
//  Copyright © 2015年 Rail Bu. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class CityPickerInterfaceController: WKInterfaceController {
    
    // MARK: Properties
    @IBOutlet var provinceName: WKInterfacePicker!
    @IBOutlet var cityName: WKInterfacePicker!
    let json: JSON = JSON.null
    let path = NSBundle.mainBundle().pathForResource("city", ofType:"json")
    var pickerValue = 0
    var citys: [JSON] = []
    var cityNames: [String] = []

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let nsUrl = NSURL(fileURLWithPath: self.path!)
        let nsData: NSData = NSData(contentsOfURL: nsUrl)!
        let ci = JSON(data: nsData)
    
        var items = [WKPickerItem]()
        
        
        
        for (_ , subJson): (String, JSON) in ci {
            for(key , cityJson): (String, JSON) in subJson {
                if key == "name" {
                    let picker = WKPickerItem()
                    picker.title = cityJson[].string
                    items.append(picker)
                }
                if key == "city" {
                    citys.append(cityJson)
                }
            }
            
            
        }
        
        self.provinceName?.setItems(items)
        self.provinceName?.setEnabled(true)
        
//        if let city = context as? String {
//            
//            cityName.setSelectedItemIndex(data.indexOf(city)!)
//        }
        
        
        // Configure interface objects here.
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
    @IBAction func returnAction() {
        pushControllerWithName("WeatherInterface", context: cityNames[self.pickerValue])
        
    }
    
    @IBAction func cityPicker(value: Int) {
        self.pickerValue = value
    }
    
    @IBAction func provincePicker(value: Int) {
        var items = [WKPickerItem]()
        
        cityNames = []
        
        for (_ , subJson): (String, JSON) in citys[value] {
            for(key , cityJson): (String, JSON) in subJson {
                if key == "name" {
                    let picker = WKPickerItem()
                    picker.title = cityJson[].string
                    items.append(picker)
                    cityNames.append(picker.title!)
                }
            }
        }
        
        self.cityName?.setItems(items)
        self.cityName?.setEnabled(true)
        
    }
    
}
