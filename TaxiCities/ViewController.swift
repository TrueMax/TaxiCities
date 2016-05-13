//
//  ViewController.swift
//  TaxiCities
//
//  Created by Maxim on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isLoadingData = false
    var json: JSON?
    @IBOutlet weak var tableView: UITableView!
    var cities: [City] = []
    var selectedCityName = ""
    var selectedCity: City?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 66
        var cellNib = UINib(nibName: "CityCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "CityCell")
        
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "LoadingCell")
        
        loadData()
    }
    
//MARK: - Networking Methods 
    
    func loadData() {
        
        isLoadingData = true
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://beta.taxistock.ru/taxik/api/client/query_cities")
        let dataTask = session.dataTaskWithURL(url!, completionHandler: { [weak self] data, response, error in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self!.showNetworkError()
                }
            }
            
            guard let response = response as? NSHTTPURLResponse where response.statusCode == 200 else {
                dispatch_async(dispatch_get_main_queue()){
                self!.showServerError()
                }
                return
            }
            
            if let jsonData = data {
                
                if let strongSelf = self {strongSelf.json = JSON(data: jsonData)
                    strongSelf.cities = strongSelf.parseCities(strongSelf.json!)!
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self!.showJsonError()
                }
            }
            
            dispatch_async(dispatch_get_main_queue()){
                
                self!.isLoadingData = false
                self!.tableView.reloadData()
            }
        })
        
        dataTask.resume()
    }
    
    func showNetworkError() {
            let controller = UIAlertController(title: "Ошибка сети", message: nil, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Проверьте соединение", style: .Default, handler: nil))
            controller.addAction(UIAlertAction(title: "Закрыть", style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
    }
    
    func showServerError() {
            let controller = UIAlertController(title: "Ошибка сервера", message: nil, preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Сервер не отвечает", style: .Default, handler: nil))
            controller.addAction(UIAlertAction(title: "Закрыть", style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
    }
    
    func showJsonError() {
            let controller = UIAlertController(title: "Формат данных", message: "НЕ JSON", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Сервер отдал не то", style: .Default, handler: nil))
            controller.addAction(UIAlertAction(title: "Закрыть", style: .Cancel, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
    }
    
//MARK: - Parsing Data Methods
    
    func parseCities(json: JSON) -> [City]? {
        
        
        var cities: [City] = []
        let jsonArray = json["cities"].arrayValue
        for dictionary in jsonArray {
            let city = City()
            let cityName = dictionary["city_name"].stringValue
            let latitude = dictionary["city_latitude"].doubleValue
            let longitude = dictionary["city_longitude"].doubleValue
            
            city.name = cityName
            city.latitude = latitude
            city.longitude = longitude
            cities.append(city)
        }
        return cities
    }
    
//MARK: - TableView Methods

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadingData {
            return 1
        } else {
            return cities.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoadingData {
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadingCell", forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) as! CityCell
            
            let city = cities[indexPath.row]
            cell.configureCity(city)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCityName = cities[indexPath.row].name
        selectedCity = cities[indexPath.row]
        performSegueWithIdentifier("ShowCity", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCity" {
            let navcontroller = segue.destinationViewController as! UINavigationController
            let controller = navcontroller.topViewController as! MapViewController
            controller.navigationItem.title = selectedCityName
            controller.cityName = (selectedCity?.name)!
            controller.cityLatitude = (selectedCity?.latitude)!
            controller.cityLongitude = (selectedCity?.longitude)!
        }
    }
    
}

