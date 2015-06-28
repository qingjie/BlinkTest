//
//  ViewController.swift
//  BlinkTest
//
//  Created by qingjiezhao on 6/24/15.
//  Copyright (c) 2015 qingjiezhao. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITextFieldDelegate{
    var objects = [[String : String]]()
   
    @IBOutlet weak var txtReg: UITextField!
    @IBOutlet weak var textNum: UITextField!
    
    @IBAction func getList(sender: AnyObject) {
        testGet()
    }
    
    func testGet(){
        let m:Int! = (textNum.text).toInt()
        if m >= 1{
            for (var i = 0; i < m; i++){
                get("http://52.5.223.80:4567/network/1/cameras")
            }
        }
        
    }


    @IBAction func okTapped(sender: AnyObject) {
        testPost()
    }
    let diceRoll = Int(arc4random_uniform(7))
    
    func testPost(){
        let n:Int? = (txtReg.text).toInt()
        if n >= 1 {
            for (var i = 0; i < n; i++){
                //let diceRoll = Int(arc4random_uniform(7))
                let dic:Dictionary<String, String> = ["email":"\(Timestamp)@blink.com", "password":"aa", "password_confirm":"aa", "name":"aa","phone_number":"111-123","client_name":"aa","client_type":"ios","client_specifier":"OS","notification_key":"APNS"]
                post(dic, url: "http://52.5.223.80:4567/account/register")
            }
        }
    }
    
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textNum.delegate = self
        txtReg.delegate = self
        println("Timestamp: \(Timestamp)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func post(params : Dictionary<String, String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var accessToken = ""
        
        var err: NSError?
        print(params)
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //request.setValue("access_token=\(accessToken)", forHTTPHeaderField:"Authorization")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
           
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    if let success = parseJSON["success"] as? Bool {
                        println("Succes: \(success)")
                                            }
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
       
        task.resume()
    }
    
    
    func get(url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        var accessToken = "xFvsYHrnssoOFwvNixX5ug"
        
        var err: NSError?
        
        //request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField:"TOKEN_AUTH")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            var msg = "No message"
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    if let success = parseJSON["success"] as? Bool {
                        println("Succes: \(success)")
                    }
                    return
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }

}

