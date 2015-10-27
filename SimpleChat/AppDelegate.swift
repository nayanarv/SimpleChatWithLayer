//
//  AppDelegate.swift
//  SimpleChat
//
//  Created by Nayana on 27/10/15.
//  Copyright © 2015 Nayana. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    #if TARGET_IPHONE_SIMULATOR
     let userIDString = "Simulator"
    #else
     let userIDString = "Phone"
    #endif
    var window: UIWindow?
    var layerClient: LYRClient!
    var controller: ViewController!
    
    let appID = NSURL(string: "layer:///apps/staging/399fab32-7646-11e5-a321-70c100000104")
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        layerClient = LYRClient(appID: appID)
        layerClient.connectWithCompletion { (success, lerror) -> Void in
            if success
            {
                print("connected")
                
                self.authenticateLayerWithUserID(self.userIDString, completion: { (success, error) -> Void in
                    if (!success)
                    {
                        print("auth error - ", error.description)
                    }
                })
            }
        }
        controller = ViewController()
        //        controller.layerClient = layerClient
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - Layer
    
    func authenticateLayerWithUserID(userID: NSString, completion: ((success: Bool , error: NSError!) -> Void)!) {
        // Check to see if the layerClient is already authenticated.
        if self.layerClient.authenticatedUserID != nil {
            // If the layerClient is authenticated with the requested userID, complete the authentication process.
            print(userID)
            if self.layerClient.authenticatedUserID == userID {
                print("Layer Authenticated as User \(self.layerClient.authenticatedUserID)")
                if completion != nil {
                    completion(success: true, error: nil)
                }
                return
            } else {
                //If the authenticated userID is different, then deauthenticate the current client and re-authenticate with the new userID.
                self.layerClient.deauthenticateWithCompletion { (success: Bool, error: NSError!) in
                    if error != nil {
                        print(error.description)
                        self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError?) in
                            if (completion != nil) {
                                completion(success: success, error: error)
                            }
                        })
                    } else {
                        if completion != nil {
                            completion(success: true, error: error)
                            print("user eror - ", error)
                        }
                    }
                }
            }
        } else {
            // If the layerClient isn't already authenticated, then authenticate.
            self.authenticationTokenWithUserId(userID, completion: { (success: Bool, error: NSError!) in
                if completion != nil {
                    completion(success: success, error: error)
                }
            })
        }
    }
    
    func authenticationTokenWithUserId(userID: NSString, completion:((success: Bool, error: NSError!) -> Void)!) {
        /*
        * 1. Request an authentication Nonce from Layer
        */
        self.layerClient.requestAuthenticationNonceWithCompletion { (nonce: String!, error: NSError!) in
            if (nonce.isEmpty) {
                if (completion != nil) {
                    completion(success: false, error: error)
                }
                return
            }
            /*
            * 2. Acquire identity Token from Layer Identity Service
            */
            self.requestIdentityTokenForUserID(userID, appctnId: String(self.layerClient.appID), nonce: nonce, completion: { (identityToken, error) -> Void in
                if(identityToken != "")
                {
                    if (completion != nil)
                    {
                        completion(success: false, error: error)
                    }
                    return
                }
                /*
                * 3. Submit identity token to Layer for validation
                */
                self.layerClient.authenticateWithIdentityToken(identityToken as String, completion: { (authenticatedUserID, error) -> Void in
                    if((authenticatedUserID) != nil)
                    {
                        if((completion) != nil)
                        {
                            completion(success: true, error: nil)
                        }
                        print("authenticatd user id", identityToken)
                    }
                    else
                    {
                        completion(success: false, error: error)
                        
                    }
                })
            })
        }
    }
    
    func requestIdentityTokenForUserID(userID: NSString, appctnId: NSString, nonce: NSString, completion:((identityToken: NSString, error: NSError!) -> Void)!) {
        
        let identityTokenURL = NSURL(string: "https://layer-identity-provider.herokuapp.com/identity_tokens")
        let request = NSMutableURLRequest(URL: identityTokenURL!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let parameters: NSDictionary = ["app_id" :appctnId, "user_id" : userID, "nonce" : nonce]
        let requestBody = try!  NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        request.HTTPBody = requestBody
        let sessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfiguration)
        session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if (error != nil)
            {
                
                completion(identityToken: "", error: error)
            }
            let responseObject: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
            if((responseObject .valueForKey("error")) != nil)
            {
                let identityTokn: NSString = responseObject .valueForKey("identity_token") as! NSString
                completion(identityToken: identityTokn, error: nil)
            }
            else
            {
                
            }
            
        }
        
    }
    
    
    
}

