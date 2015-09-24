//
//  File.swift
//  ConnectionTester
//
//  Created by Ludvig Fröberg on 08/06/15.
//  Copyright (c) 2015 GameQ AB. All rights reserved.
//

import Foundation
import UIKit
import CoreData



class ConnectionHandler : NSObject {
    
    static let baseURL:String = "http://server.gameq.io:8080/ios/"
    static let devURL:String = "http://dev.gameq.io:8080/ios/"
    static let deviceIdKey:String = "device_id_key"
    static let passwordKey:String = "password_key"
    static let emailKey:String = "email_key"
    static let tokenKey:String = "token_key"
    static var firstLogin:Bool = false
    static var delayToServer:Int = 0
    private static var acceptServerIp = "127.0.0.1"
    private static var sessionId:String = ""
    private static let lockQueue = dispatch_queue_create("io.gameq.waitforloginqueue", nil)
    private static let loginSemaphore:dispatch_semaphore_t = dispatch_semaphore_create(1);
    private static let backgroundQueue = dispatch_queue_create("io.gameq.asyncnetworking", nil)
    private static var autoAccepts:Bool = false
    
    
    
    private static func getStringFrom(json:Dictionary<String, AnyObject>, key:String) -> String {
        if let value = (json[key] as? String) {
            return value
        } else { return "" }
    }
    
    private static func getIntFrom(json:Dictionary<String, AnyObject>, key:String) -> Int {
        if let value = json[key] as? Int {
            //            println("value: \(value)")
            return value
        } else { return 0 }
    }
    
    private static func postRequest(arguments:String, apiExtension:String, responseHandler:(responseJSON:AnyObject!) -> ()) {
        let urlString = "\(baseURL)\(apiExtension)?"
        print(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "key=68440fe0484ad2bb1656b56d234ca5f463f723c3d3d58c3398190877d1d963bb&\(arguments)".dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                let Json:Dictionary<String, AnyObject> = [
                    "success": 0,
                    "error": 404
                ]
                responseHandler(responseJSON: Json)
                return
            }
            
            //println("response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            let responseJSON:AnyObject!
            do {
                responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                responseJSON = nil
            }
            responseHandler(responseJSON: responseJSON)
        }
        task.resume()
    }
    
    private static func postDevRequest(arguments:String, apiExtension:String, responseHandler:(responseJSON:AnyObject!) -> ()) {
        let urlString = "\(devURL)\(apiExtension)?"
        print(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = "key=68440fe0484ad2bb1656b56d234ca5f463f723c3d3d58c3398190877d1d963bb&\(arguments)".dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                let Json:Dictionary<String, AnyObject> = [
                    "success": 0,
                    "error": 404
                ]
                responseHandler(responseJSON: Json)
                return
            }
            
            //println("response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            let responseJSON:AnyObject!
            do {
                responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                responseJSON = nil
            }
            responseHandler(responseJSON: responseJSON)
        }
        task.resume()
    }
    
    private static func postBack(arguments:String, apiExtension:String, responseHandler:(responseJSON:AnyObject!) -> ()) {
        let urlString = "http://\(acceptServerIp):8080/ios/\(apiExtension)?"
        print(urlString)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        
        request.HTTPBody = "key=68440fe0484ad2bb1656b56d234ca5f463f723c3d3d58c3398190877d1d963bb&\(arguments)".dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                let Json:Dictionary<String, AnyObject> = [
                    "success": 0,
                    "error": 404
                ]
                responseHandler(responseJSON: Json)
                return
            }
            
            //println("response = \(response)")
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
            let responseJSON:AnyObject!
            do {
                responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            } catch _ {
                responseJSON = nil
            }
            responseHandler(responseJSON: responseJSON)
        }
        task.resume()
    }
    
    static func login(email:String, password password1:String, finalCallBack:(success:Bool, err:String?)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        var password:String = password1
        if !self.firstLogin {
            password = self.sha256(password1)
            print("")
            self.firstLogin = false
        }
        
        let apiExtension = "login"
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        var tokenString = ""
        if let token = self.loadToken() { //only mobile
            tokenString = "push_token=\(token)"
        }
        if let smth = ConnectionHandler.loadOldToken() {
            if smth == LeftViewController.emptyString {
                tokenString = "push_token=\(LeftViewController.emptyString)"
            }
        }
        
        
        
        
        
        let arguments = "email=\(email)&password=\(password)&\(tokenString)&\(diString)"
        print("???")
        print(password)
        print(password1)
        print(email)
        
            self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                var success:Bool = false
                var err:String? = nil
                print("post request done")
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    let serverTime = self.getIntFrom(json, key: "time")
                    self.delayToServer = Int(NSDate().timeIntervalSince1970) - serverTime
                    success = self.getIntFrom(json, key: "success") != 0
                    if !success {
                        err = self.getStringFrom(json, key: "error")
                    } else {
                        self.savePassword(password)
                        self.saveEmail(email)
                        let retDI = self.getIntFrom(json, key: "device_id")
                        print("returned DI: \(retDI)")
                        if retDI != 0 {
                            self.saveDeviceId("\(retDI)")
                            print("saved DI")
                            
                        }
                        self.sessionId = self.getStringFrom(json, key: "session_token")
                    }
                } else {
                    print("json parse fail")
                    err = "Connection failure"
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                finalCallBack(success: success, err: err)
            })
            
        

        })
                
        
    }
    
    static func logout(finalCallBack:(success:Bool, err:String?)->()) {
        let apiExtension = "logout"
        var diString = ""
        if let deviceId = loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "session_token=\(sessionId)&\(diString)"
        postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                success = self.getIntFrom(json, key: "success") != 0
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    //logout success
                    
                    self.sessionId = ""
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            self.saveEmail("")
            self.savePassword("")
            finalCallBack(success: success, err: err)
        })
    }
    
    static func register(email:String, password password1:String, finalCallBack:(success:Bool, err:String?)->()) {
        let password = sha256(password1)
        let apiExtension = "register"
        var diString = ""
        if let deviceId = loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        var tokenString = ""
        if let token = loadToken() { //only mobile
            tokenString = "push_token=\(token)"
        }
        if let smth = ConnectionHandler.loadOldToken() {
            if smth == LeftViewController.emptyString {
                tokenString = "push_token=\(LeftViewController.emptyString)"
            }
        }
        let arguments = "email=\(email)&password=\(password)&\(tokenString)&\(diString)"
        postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                let serverTime = self.getIntFrom(json, key: "time")
                self.delayToServer = Int(NSDate().timeIntervalSince1970) - serverTime
                success = self.getIntFrom(json, key: "success") != 0
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    self.savePassword(password)
                    self.saveEmail(email)
                    let retDI = self.getStringFrom(json, key: "device_id")
                    if retDI != ""{
                        self.saveDeviceId(retDI)
                    }
                    self.sessionId = self.getStringFrom(json, key: "session_token")
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            
            finalCallBack(success: success, err: err)
        })
    }
    
    
    
    static func getStatus(finalCallBack:(success:Bool, err:String?, status:Int, game:Int?, acceptBefore:Int)->()) {
        
        
        
        let apiExtension = "getStatus"
        var diString = ""
        if let deviceId = loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        print("")
        let arguments = "session_token=\(sessionId)&\(diString)"
        print(arguments)
        
        
        self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            var game:Int? = nil
            var status:Int = 0
            var acceptBefore:Int = 0
            
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                success = self.getIntFrom(json, key: "success") != 0
                acceptBefore = self.getIntFrom(json, key: "accept_before")
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    //success
                    game = self.getIntFrom(json, key: "game")
                    status = self.getIntFrom(json, key: "status")
                    if status == 4 {
                        self.acceptServerIp = self.getStringFrom(json, key: "ip")
                    }
                    if game == 0 {
                        game = nil
                    }
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            finalCallBack(success: success, err: err, status:status, game:game, acceptBefore:acceptBefore)
        })
        
        
        
    }
    
    static func acceptQueue(accept:Bool, finalCallBack:(success:Bool, err:String?)->()) {
        let apiExtension = "accept"
        var diString = ""
        if let deviceId = loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        var aa:Int = 0
        if accept {
            aa = 1
        }
        let arguments = "session_token=\(sessionId)&\(diString)&accept=\(aa)"
        print(arguments)
        postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                success = self.getIntFrom(json, key: "success") != 0
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    //success
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            
            finalCallBack(success: success, err: err)
        })
    }
    
    static func updateToken(token:String, finalCallBack:(success:Bool, err:String?)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        let apiExtension = "updateToken"
        self.saveToken(token)
        self.saveOldToken(token)
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "session_token=\(self.sessionId)&\(diString)&push_token=\(token)"
        print(arguments)
        
            self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                var success:Bool = false
                var err:String? = nil
                
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    print(json)
                    success = self.getIntFrom(json, key: "success") != 0
                    if !success {
                        err = self.getStringFrom(json, key: "error")
                    } else {
                        //success
                    }
                } else {
                    print("json parse fail")
                    err = "Connection failure"
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                finalCallBack(success: success, err: err)
            })
        })
        
            
            
       
        
        
    }
    
    
    
    static func versionControl(finalCallBack:(success:Bool, err:String?, newestVersion:String?, link:String?)->()) {
        let apiExtension = "versionControl"
        let arguments = ""
        //let arguments = "os=mac" //os = mac or os = pc , only used by computers
        postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            var newestVersion:String? = nil
            var downloadLink:String? = nil
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                success = self.getIntFrom(json, key: "success") != 0
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    //success
                    newestVersion = self.getStringFrom(json, key: "current_version")
                    downloadLink = self.getStringFrom(json, key: "download_link")
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            
            finalCallBack(success: success, err: err, newestVersion:newestVersion, link:downloadLink)
        })
    }
    
    
    static func submitFeedback(feedbackString:String, finalCallBack:(success:Bool, err:String?)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        let apiExtension = "storeFeedback"
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "session_token=\(self.sessionId)&\(diString)&feedback=\(feedbackString)"
            self.postDevRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                var success:Bool = false
                var err:String? = nil
                
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    success = self.getIntFrom(json, key: "success") != 0
                    if !success {
                        err = self.getStringFrom(json, key: "error")
                    } else {
                        //csv submission succeeded
                    }
                } else {
                    print("json parse fail")
                    err = "Connection failure"
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                finalCallBack(success: success, err: err)
            })
        })
        
            
            
        
        
    }
    
    
    static func updatePassword(email:String, password password1:String, newPassword newPassword1:String, finalCallBack:(success:Bool, err:String?)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        let password = self.sha256(password1)
        let newPassword = self.sha256(newPassword1)
        let apiExtension = "updatePassword"
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "email=\(email)&password=\(password)&new_password=\(newPassword)&\(diString)&session_token=\(self.sessionId)"
            self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                var success:Bool = false
                var err:String? = nil
                
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    success = self.getIntFrom(json, key: "success") != 0
                    if !success {
                        err = self.getStringFrom(json, key: "error")
                    } else {
                        self.savePassword(newPassword)
                        let retDI = self.getStringFrom(json, key: "device_id")
                        if retDI != ""{
                            self.saveDeviceId(retDI)
                        }
                        self.sessionId = self.getStringFrom(json, key: "session_token")
                    }
                } else {
                    print("json parse fail")
                    err = "Connection failure"
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                finalCallBack(success: success, err: err)
            })
        })
        
            
            
        
        
    }
    
    static func forgotPassword(email:String, finalCallBack:(success:Bool, err:String?)->()) {
        let apiExtension = "forgotPassword"
        let arguments = "email=\(email)"
        postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
            var success:Bool = false
            var err:String? = nil
            
            if let json = responseJSON as? Dictionary<String, AnyObject> {
                success = self.getIntFrom(json, key: "success") != 0
                if !success {
                    err = self.getStringFrom(json, key: "error")
                } else {
                    //success mothafucka
                }
            } else {
                print("json parse fail")
                err = "Connection failure"
            }
            
            finalCallBack(success: success, err: err)
        })
    }
    
    static func loginWithRememberedDetails(finalCallBack:(success:Bool, err:String?)->()) {
        var s:Bool = false
        if let email = loadEmail() {
            if let password = loadPassword() {
                if email != "" && password != "" {
                    s = true
                    self.login(email, password: password, finalCallBack: { (success:Bool, err:String?) in
                        finalCallBack(success: success, err: err)
                        self.firstLogin = false
                    })
                }
            }
        }
        if !s {
            finalCallBack(success: false, err: "Unable to load previous login details!")
            firstLogin = false
        }
    }
    
    static func getAutoAccept(finalCallBack:(autoAcceptEnabled:Bool)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        let apiExtension = "getAutoAccept"
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "session_token=\(self.sessionId)&\(diString)"
        print("AA arguments: \(arguments)")
        finalCallBack(autoAcceptEnabled: self.autoAccepts)
            self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                
                var success:Bool = false
                var enabled = false
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    success = self.getIntFrom(json, key: "success") != 0
                    if success && self.getStringFrom(json, key: "error") == "accept" {
                        enabled = true
                    } else {
                        enabled = false
                    }
                } else {
                    print("json parse fail")
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                if self.autoAccepts != enabled {
                    self.autoAccepts = enabled
                    finalCallBack(autoAcceptEnabled: self.autoAccepts)
                }
                
            })
            
        })
        
            
        
        
    }
    
    static func updateAutoAccept(enableAccept:Bool, finalCallBack:(success:Bool, err:String?)->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_semaphore_wait(self.loginSemaphore, DISPATCH_TIME_FOREVER)
        let previousSetting = self.autoAccepts
        self.autoAccepts = enableAccept
        let apiExtension = "updateAutoAccept"
        var diString = ""
        if let deviceId = self.loadDeviceId() {
            diString = "device_id=\(deviceId)"
        }
        let arguments = "session_token=\(self.sessionId)&\(diString)&auto_accept=\(enableAccept ? 1 : 0)"
            self.postRequest(arguments, apiExtension: apiExtension, responseHandler: {(responseJSON:AnyObject!) in
                var success:Bool = false
                var err:String? = nil
                
                if let json = responseJSON as? Dictionary<String, AnyObject> {
                    success = self.getIntFrom(json, key: "success") != 0
                    if !success {
                        self.autoAccepts = previousSetting
                        err = self.getStringFrom(json, key: "error")
                    } else {
                        //update auto accept success
                    }
                } else {
                    print("json parse fail")
                    err = "Connection failure"
                    self.autoAccepts = previousSetting
                }
                dispatch_semaphore_signal(self.loginSemaphore)
                finalCallBack(success: success, err: err)
            })
            })
        
            
           
        
        
    }
    
    
    
    
    
    
    
    
    private static func saveOldToken(token:String) {
        saveSingle("last_submitted_token", value: token)
    }
    
    static func loadOldToken() -> (String?){
        return loadSingle("last_submitted_token") as? String
    }
    
    
    static func saveToken(token:String) {
        saveSingle(tokenKey, value: token)
    }
    
    static func loadToken() -> (String?){
        return loadSingle(tokenKey) as? String
    }
    
    private static func saveDeviceId(deviceId:String) {
        saveSingle(deviceIdKey, value: deviceId)
    }
    
    private static func loadDeviceId() -> (String?){
        return loadSingle(deviceIdKey) as? String
    }
    
    private static func saveEmail(email:String) {
        saveSingle(emailKey, value: email)
    }
    
    static func loadEmail() -> (String?){
        return loadSingle(emailKey) as? String
    }
    
    private static func savePassword(password:String) {
        saveSingle(passwordKey, value: password)
    }
    
    private static func loadPassword() -> (String?){
        return loadSingle(passwordKey) as? String
    }
    
    
    
    /**
    input: A String containing the attribute name
    output: N/A
    description: Saves attribute to disk
    */
    private class func saveSingle(attribute:String, value:AnyObject) {
        let entity = "Singles"
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName:entity)
        
        
        var fetchedResults = []
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch _ {
            
        }
        
        if fetchedResults.count > 0 {
            for result in fetchedResults {
                result.setValue(value, forKey:attribute)
            }
            do {
                try managedContext.save()
            } catch _ {
                //                    println("saveSingle1 Could not save \(error2), \(error2?.userInfo)")
            }
        } else {
            //-----
            let entityDesc =  NSEntityDescription.entityForName(entity,
                inManagedObjectContext:
                managedContext)
            
            let managedObject = NSManagedObject(entity: entityDesc!,
                insertIntoManagedObjectContext:managedContext)
            
            managedObject.setValue(value, forKey: attribute)
        }
        
        
        
        
        
        do {
            try managedContext.save()
        } catch _ {
            //            println("saveSingle2 Could not save \(error2), \(error2?.userInfo)")
        }
        
    }
    
    
    
    /**
    input: the attribute name
    output: An object representing the attribute
    description: Loads attribute from disk
    */
    private class func loadSingle(attribute:String) -> AnyObject? {
        //        println("loading \(attribute) for Singles")
        let entity = "Singles"
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        //2
        let fetchRequest = NSFetchRequest(entityName:entity)
        
        //3
        
        var fetchedResults = []
        do {
            fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch _ {
            
        }
        
        if fetchedResults.count > 0 {
            //                println("found entries")
            //                println("\(results[0].valueForKey(attribute))")
            return fetchedResults[0].valueForKey(attribute)
        } else {
            //                println("no results")
            return nil
        }
        
        
    }
    
    
    static func firstLaunch() -> Bool {
        if let smth = loadSingle("unopened") as? String {
            if smth != "something" {
                return true
            }
            return false
        }
        saveSingle("unopened", value: "something")
        return true
    }
    
    
    static func sha256(aString : String) -> String {
        let data:NSData = aString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        return res.description.stringByReplacingOccurrencesOfString("<", withString: "").stringByReplacingOccurrencesOfString(">", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    
}













