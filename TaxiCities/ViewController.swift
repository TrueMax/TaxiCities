//
//  ViewController.swift
//  TaxiCities
//
//  Created by Maxim on 12.05.16.
//  Copyright © 2016 Maxim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isLoadingData = false
    var json: JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    func loadData() {
        
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "http://beta.taxistock.ru/taxik/api/client/query_cities")
        let dataTask = session.dataTaskWithURL(url!){ [weak self] data, response, error in
            
            if error != nil {
                self!.showNetworkError()
            }
            
            guard let response = response as? NSHTTPURLResponse where response.statusCode == 200 else {
                self!.showServerError()
                return
            }
            
            guard let jsonData = data else {
                self!.showJsonError()
                return
            }
            
            self!.json = self!.parseJsonData(jsonData)
            
        }
        
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
    
    func parseJsonData(data: NSData) -> JSON? {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSON
        } catch {
            showJsonError()
            return nil
        }

        
    }

}

