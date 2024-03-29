//
//  FirebasePushNotificationManager.swift
//  my-sibgu
//
//  Created by art-off on 12.01.2021.
//

import Firebase
import NotificationService

class FirebasePushNotificationManager: NSObject {
    
    
    func registerForRemotePushNotifications() {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        let authOptiona: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptiona,
            completionHandler: { isFine, error in
                NSLog("Conected to Firebase - \(isFine)")
                guard error == nil else {
                    NSLog(error!.localizedDescription)
                    return
                }
            }
        )
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
}

extension FirebasePushNotificationManager: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        subscribeToTopics()
    }
    
    @objc private func subscribeToTopics() {
        ["allUsers_ios", UserService().getCurrUser()?.token]
            .compactMap { $0 }
            .forEach { topic in
                Self.subscribe(to: topic)
            }
        #if DEBUG
        Messaging.messaging().subscribe(toTopic: "debug") { error in
            print("SUBSCRIBE TO DEBUG `debug`, error \(String(describing: error))")
        }
        #endif
    }
    
    static func subscribe(to topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in
            print("Subscribe to topic `\(topic)`, error - \(String(describing: error))")
        }
    }
    
    static func unsubscribe(from topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in
            print("Unsubscribe from topic `\(topic)`, error - \(String(describing: error))")
        }
    }
}

extension FirebasePushNotificationManager: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        // MARK: Тут можно обработать пуши, когда они прилетают, а пользователь находится в приложении
        print("hello1111")
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        // MARK: Тут можно обработать пуши, когда они прилетают, а пользователь щас не юзает приложение
        // MARK: Или оно срабатывает, когда чел тыкает на уведомление, даже внутри приложения
        print("hello2222")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let clickAction = userInfo["click_action"] as? String {
                CODE_TO_SCREEN_OPENING[clickAction]?(MAIN_NAVIGATION_CONTROLLER!)
            }
        }
        
        completionHandler()
    }
    
}

private let CODE_TO_SCREEN_OPENING: [String: (UINavigationController) -> Void] = [
    "FEED": { navController in
        (navController.viewControllers.first as? UITabBarController)?.selectedIndex = 0
    },
    "TIMETABLE": { navController in
        (navController.viewControllers.first as? UITabBarController)?.selectedIndex = 2
    },
    "ATTESTATION": { navController in
        let vc = AttestaionViewController()
        navController.pushViewController(vc, animated: true)
    },
    "RECORD_BOOK": { navController in
        let vc = MarksViewController()
        navController.pushViewController(vc, animated: true)
    },
    "MY_QUESTIONS": { navController in
        let vc = FAQViewController()
        vc.mode = .myQuestions
        navController.pushViewController(vc, animated: true)
    }
]


extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
}


class TestTestViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
