//
//  tagtimeApp.swift
//  tagtime
//
//  Created by Alexander Schell on 3/12/23.
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Request permission to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            // Handle errors
        }
        
        // Set the delegate to handle notification responses
        UNUserNotificationCenter.current().delegate = self
        
        return true
        
        // Handle notification responses
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
//            let ts = response.notification.request.content.body
            
            if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            
//                let destView = ContentView()
//                window?.rootViewController?.present(destView, animated: true, completion: nil)

            }
            
            completionHandler()
        }
    }
}

class Observer: ObservableObject {
    @Published var enteredForeground = true

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIScene.willEnterForegroundNotification, object: nil)
    }

    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

@main
struct tagtimeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
