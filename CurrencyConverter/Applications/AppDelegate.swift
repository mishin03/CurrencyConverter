//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Илья Мишин on 02.06.2023.
//

import UIKit
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Initialize OneSignal
            OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
            OneSignal.setAppId("YOUR_ONESIGNAL_APP_ID")
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                // Handle user response to push notification prompt
            })
            
            // Other code in didFinishLaunchingWithOptions
            
            return true
        }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

