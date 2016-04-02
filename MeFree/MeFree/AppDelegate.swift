/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

// If you want to use any of the UI components, uncomment this line
//import ParseUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var friendsOfUser = [PFUser]()
    
    


    //--------------------------------------
    // MARK: - UIApplicationDelegate
    //--------------------------------------

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Enable storing and querying data from Local Datastore.
        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "MeFree"
            ParseMutableClientConfiguration.clientKey = "DJAZmefree4"
            ParseMutableClientConfiguration.server = "https://mefree.herokuapp.com/parse"
        })
        
        Parse.initializeWithConfiguration(parseConfiguration)


        // ****************************************************************************
        // Uncomment and fill in with your Parse credentials:
        // Parse.setApplicationId("your_application_id", clientKey: "your_client_key")
        //
        // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
        // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
        // Uncomment the line inside ParseStartProject-Bridging-Header and the following line here:
        // PFFacebookUtils.initializeFacebook()
        // ****************************************************************************

        PFUser.enableAutomaticUser()

        let defaultACL = PFACL();

        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        defaultACL.publicWriteAccess = true

        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)

        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.

            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(#selector(UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:)))
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }

        //print(PFUser.currentUser())
        
        //--------------------------------------
        // MARK: - friend / user Query
        //--------------------------------------
        if (PFUser.currentUser()?.objectId == "" || PFUser.currentUser()?.objectId == nil) {
            print("no user")
            
        } else {
            updateFriendList()
        }

        

        //
        //  Swift 1.2
        //
        //        if application.respondsToSelector("registerUserNotificationSettings:") {
        //            let userNotificationTypes = UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound
        //            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        } else {
        //            let types = UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound
        //            application.registerForRemoteNotificationTypes(types)
        //        }

        //
        //  Swift 2.0
        //
        //        if #available(iOS 8.0, *) {
        //            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        //            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        //            application.registerUserNotificationSettings(settings)
        //            application.registerForRemoteNotifications()
        //        } else {
        //            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
        //            application.registerForRemoteNotificationTypes(types)
        //        }

        return true
    }
    
    func updateFriendList () {
        //if login, has to do this manually and update friends / users
        self.friendsOfUser.removeAll()
        let userCheckOne = PFQuery(className: "Friendships")
        userCheckOne.whereKey("userB", equalTo: PFUser.currentUser()!)
        
        let userCheckTwo = PFQuery(className: "Friendships")
        userCheckTwo.whereKey("userA", equalTo: PFUser.currentUser()!)
        
        let userCheck = PFQuery.orQueryWithSubqueries([userCheckOne, userCheckTwo])
        userCheck.includeKey("userA")
        userCheck.includeKey("userB")
        
        do {
            let results: [PFObject] = try userCheck.findObjects()
            print("what updateFriendList finds \(results)")
            for object in results {
                if var user = object["userA"] as? PFUser {
                    if user.objectId != PFUser.currentUser()?.objectId {
                        //print("appendA")
                        self.friendsOfUser.append(user)
                    } else {
                        user = (object["userB"] as? PFUser)!
                        if user.objectId != PFUser.currentUser()?.objectId {
                            //print("appendB")
                            self.friendsOfUser.append(user)
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        
        
        /*
        var objects = userCheck.findObjects() as [PFObject]
            for object in objects! {
                if var user = object["userA"] as? PFUser {
                    if user.objectId != PFUser.currentUser()?.objectId {
                        //print("appendA")
                        self.friendsOfUser.append(user)
                    } else {
                        user = (object["userB"] as? PFUser)!
                        if user.objectId != PFUser.currentUser()?.objectId {
                            //print("appendB")
                            self.friendsOfUser.append(user)
                        }
                    }
                }
            }
            print("friendsOfUser")
            print(self.friendsOfUser)
        }
        */

        
    }
    
    func returnFriends() -> [PFUser] {
        print("friends passed from returnFriends in app delegate: \(friendsOfUser)")
        return friendsOfUser
    }
    

    //--------------------------------------
    // MARK: Push Notifications
    //--------------------------------------

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()

        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("ParseStarterProject successfully subscribed to push notifications on the broadcast channel.\n");
            } else {
                print("ParseStarterProject failed to subscribe to push notifications on the broadcast channel with error = %@.\n", error)
            }
        }
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@\n", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
    }

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you want to use Push Notifications with Background App Refresh
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
    //     if application.applicationState == UIApplicationState.Inactive {
    //         PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
    //     }
    // }

    //--------------------------------------
    // MARK: Facebook SDK Integration
    //--------------------------------------

    ///////////////////////////////////////////////////////////
    // Uncomment this method if you are using Facebook
    ///////////////////////////////////////////////////////////
    // func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    //     return FBAppCall.handleOpenURL(url, sourceApplication:sourceApplication, session:PFFacebookUtils.session())
    // }
}
