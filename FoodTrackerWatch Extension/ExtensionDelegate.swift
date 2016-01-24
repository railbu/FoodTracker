//
//  ExtensionDelegate.swift
//  FoodTrackerWatch Extension
//
//  Created by rail bu on 15/12/3.
//  Copyright © 2015年 Rail Bu. All rights reserved.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate, WCSessionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    // MARK: WCSessionDelegate
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        let unachive = NSKeyedUnarchiver(forReadingWithData: messageData)
        let dic : NSDictionary = unachive.decodeObjectForKey("data") as! NSDictionary
        unachive.finishDecoding()
        
        let interfaceController = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
        
        interfaceController.mealTable.setNumberOfRows(dic.count, withRowType: "MealCell")
        
        var i = 0;
        
        for (key, value) in dic {
            let cell = interfaceController.mealTable.rowControllerAtIndex(i) as! MealCellController
            
            cell.mealImage.setImage(value as? UIImage)
            cell.mealName.setText(key as? String)
            
            i++
        }

        
//
//
//        // throw to the main queue to upate properly
//        dispatch_async(dispatch_get_main_queue()) { [weak self] in
//            // update your UI here
//        }
        
        replyHandler(messageData)
    }
    
//    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
//        
//        
//        let meals = NSKeyedUnarchiver.unarchiveObjectWithFile(String(file.fileURL)) as? [Meal]
//        
//        let interfaceController = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
//        
//        interfaceController.mealTable.setNumberOfRows(meals!.count, withRowType: "MealCell")
//        
//        var i = 0;
//        
//        for meal: Meal in meals! {
//            let cell = interfaceController.mealTable.rowControllerAtIndex(i) as! MealCellController
//            
//            cell.mealImage.setImage(meal.photo)
//            cell.mealName.setText(meal.name)
//            
//            i++
//        }
//        
//        
//    }
//
//    
//    func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
//        
//        let interfaceController = WKExtension.sharedExtension().rootInterfaceController as! InterfaceController
//        
//        interfaceController.mealTable.setNumberOfRows(applicationContext.count, withRowType: "MealCell")
//        
//        var i = 0;
//        
//        for (key, value) in applicationContext {
//            let cell = interfaceController.mealTable.rowControllerAtIndex(i) as! MealCellController
//            
//            cell.mealImage.setImage(value as? UIImage)
//            cell.mealName.setText(key)
//            
//            i++
//        }
//        
//        
//    }

}
