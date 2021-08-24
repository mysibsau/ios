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
        Messaging.messaging().subscribe(toTopic: "allUsers_ios") { error in
            print("Subscribe to topic `allUsers_ios`, error - \(String(describing: error))")
        }
        #if DEBUG
        Messaging.messaging().subscribe(toTopic: "debug_ios") { error in
            print("SUBSCRIBE TO DEBUG `debug_ios`, error \(String(describing: error))")
        }
        #endif
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            MAIN_NAVIGATION_CONTROLLER?.pushViewController(TestTestViewController(), animated: true)
//        }
        
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
            MAIN_NAVIGATION_CONTROLLER?.pushViewController(TestTestViewController(), animated: true)
        }
        
        completionHandler()
    }
    
}


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
