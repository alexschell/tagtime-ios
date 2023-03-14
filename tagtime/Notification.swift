//
//  Notification.swift
//  tagtime
//
//  Created by Alexander Schell on 3/12/23.
//

import UserNotifications

func scheduleNotification(ts: Int) {
    let notificationCenter = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = "Ping!"
    content.body = parseTS(ts)
    content.sound = UNNotificationSound.default

    let dt = ts - Int(Date().timeIntervalSince1970)

    if dt > 0 {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dt), repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request)
    }
}
