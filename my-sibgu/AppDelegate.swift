//
//  AppDelegate.swift
//  my-sibgu
//
//  Created by art-off on 12.11.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().layer.shadowColor = UIColor.black.cgColor
        UINavigationBar.appearance().layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        UINavigationBar.appearance().layer.shadowRadius = 4.0
        UINavigationBar.appearance().layer.shadowOpacity = 0.5
        UINavigationBar.appearance().layer.masksToBounds = false
        
        
//        let timetableService = TimetableService()
//        timetableService.getGroups { groups in
//            print(groups)
//        }
//        timetableService.getGroup(withId: 4) { group in
//            print(group)
//        }
//
//        timetableService.loadTimetable(
//            withId: 1071,
//            completionIfNeedNotLoadGroups: { optionalGroupTimetable in
//                print("1")
//                print(optionalGroupTimetable)
//            },
//            startIfNeedLoadGroups: {
//                print("2")
//            },
//            completionIfNeedLoadGroups: { optionalGroupTimetable in
//                print("3")
//                print(optionalGroupTimetable)
//            }
//        )
        
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

