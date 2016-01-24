    //
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by rail bu on 15/11/29.
//  Copyright © 2015年 Rail Bu. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import WatchConnectivity


class MealTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    // MARK: Properties
    var meals = [Meal]()
    var locationManager: CLLocationManager!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!

    var i = 0
    
    let locations: [String] = ["116.46,39.92","113.23,24.16","118.78,32.05","104.06,30.667"]
    
    var city: String = "北京" {
        didSet {
            self.cityName.text = city
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
       }
        
        getWeather(self.city)
        
        // 设置view的阴影边框
        self.infoView.layer.shadowOpacity = 0.8
        self.infoView.layer.shadowColor = UIColor.blackColor().CGColor
        self.infoView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        }

        
        saveMeals()

        if WCSession.defaultSession().reachable {
//            WCSession.defaultSession()
            var context: [String: UIImage]
            context = [:]
            
            for meal: Meal in meals {
                context[meal.name] = meal.photo
            }
            let data = NSMutableData()
            let archive = NSKeyedArchiver(forWritingWithMutableData: data)
            archive.encodeObject(context, forKey: "data")
            archive.finishEncoding()
            WCSession.defaultSession().sendMessageData(data, replyHandler: { (data) -> Void in
                // handle the response from the device
                
                }) { (error) -> Void in
                    print("error: \(error.localizedDescription)")
                    
            }
            //            WCSession.defaultSession() .transferFile(NSURL(fileURLWithPath: Meal.ArchiveURL.path!), metadata: [meals[0].name: meals[0].photo])

        }

        
    }
    
    func sentToWatch() {
        if WCSession.defaultSession().reachable {
            //            WCSession.defaultSession()
            var context: [String: UIImage]
            context = [:]
            
            for meal: Meal in meals {
                context[meal.name] = meal.photo
            }
            let data = NSMutableData()
            let archive = NSKeyedArchiver(forWritingWithMutableData: data)
            archive.encodeObject(context, forKey: "data")
            archive.finishEncoding()
            WCSession.defaultSession().sendMessageData(data, replyHandler: { (data) -> Void in
                // handle the response from the device
                
                }) { (error) -> Void in
                    print("error: \(error.localizedDescription)")
                    
            }
            //            WCSession.defaultSession() .transferFile(NSURL(fileURLWithPath: Meal.ArchiveURL.path!), metadata: [meals[0].name: meals[0].photo])
            
        }

    }
    
    func getWeather(city: String) {
        let url = "http://api.map.baidu.com/telematics/v3/weather"
        
        Alamofire.request(.GET, url, parameters: ["location": city, "output": "json", "ak": "n7qohMMMOQmRMPwinqpTyr3t" ])
            .responseJSON(options: NSJSONReadingOptions.MutableContainers) { response in
                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                if let data = response.result.value {
                    print(data)
                    var info:[JSON] = JSON(data)["results"].array!
                    let city = info[0]["currentCity"]
                    let weather_data = info[0]["weather_data"]
                    let weather = weather_data[0]["weather"]
                    let temperature = weather_data[0]["temperature"]
                    
                    self.cityName.text = String(city)
                    self.weatherLabel.text = String(weather)+" "+String(temperature)
                    self.weatherImage.image = UIImage(named: String(weather))
                }
        }
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        
        let longitude = currLocation.coordinate.longitude
        let latitude = currLocation.coordinate.latitude
        
        print("经度：\(longitude)")
        //获取纬度
        print("纬度：\(latitude)")
        

        getWeather(self.locations[self.i++])
        i = i % 4
    
    }
    
    // This is a helper method to load sample data into the app.
    func loadSampleMeals() {
        
        let photo1 = UIImage(named: "Image1")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "Image2")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "Image3")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        let photo4 = UIImage(named: "Image4")!
        let meal4 = Meal(name: "五花肉", photo: photo4, rating: 1)!
        
        meals += [meal1, meal2, meal3, meal4]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return meals.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MealTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell

        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        //Configure the cell...
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }
    
    //
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? MealViewController, meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                self.meals[selectedIndexPath.row] = meal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                self.meals.append(meal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
            // Save the meals.
            saveMeals()
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            
            saveMeals()
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
                
            }
        }
            
        else if segue.identifier == "AddItem" {
            
            print("Adding new meal.")
        }
        
    }
    
    // MARK: NSCoding
    func saveMeals() {
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
    
    // MARK: Action
    @IBAction func showMenu(sender: UIBarButtonItem) {
        var frame  = sender.valueForKey("view")?.frame
        frame?.origin.y += 30
        
        let foodImage = UIImage(named: "food")
        
        //配置零：内容配置
        let menuArray = [KxMenuItem.init("添加美食", image: foodImage, target: self, action: "targetMealView"),
            KxMenuItem.init("设置", image: UIImage(named: "setting"), target: self, action: "respondOfMenu:")]
//            KxMenuItem.init("创建讨论组", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
//            KxMenuItem.init("发送到电脑", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
//            KxMenuItem.init("面对面快传", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:"),
//            KxMenuItem.init("收钱", image: UIImage(named: "Touch"), target: self, action: "respondOfMenu:")]
        
        //配置一：基础配置
        KxMenu.setTitleFont(UIFont(name: "HelveticaNeue", size: 15))
        
        //配置二：拓展配置
        let options = OptionalConfiguration(arrowSize: 9,  //指示箭头大小
            marginXSpacing: 7,  //MenuItem左右边距
            marginYSpacing: 9,  //MenuItem上下边距
            intervalSpacing: 25,  //MenuItemImage与MenuItemTitle的间距
            menuCornerRadius: 6.5,  //菜单圆角半径
            maskToBackground: true,  //是否添加覆盖在原View上的半透明遮罩
            shadowOfMenu: true,  //是否添加菜单阴影
            hasSeperatorLine: false,  //是否设置分割线
            seperatorLineHasInsets: false,  //是否在分割线两侧留下Insets
            textColor: Color(R: 0, G: 0, B: 0),  //menuItem字体颜色
            menuBackgroundColor: Color(R: 1, G: 1, B: 1)  //菜单的底色
        )
        
        
        //菜单展示
        KxMenu.showMenuInView(self.view, fromRect: frame!, menuItems: menuArray, withOptions: options)
    }
    
    func targetMealView() {
        let storyBorad = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let conView = storyBorad.instantiateViewControllerWithIdentifier("AddItem")
        
        presentViewController(conView, animated: true, completion: nil)
        
        
        
        
    }
    

}
