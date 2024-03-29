//
//  NotificationPublisher.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 1/22/21.
//

import UIKit
import UserNotifications

class NotificationPublisher: NSObject {
    
    func sendNotification(title: String,
                          subtitle: String,
                          body: String,
                          delayInterval: Double?) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        var delayTimeTrigger: UNTimeIntervalNotificationTrigger?
        
        if let delayInterval = delayInterval,
           delayInterval != 0 {
            delayTimeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delayInterval), repeats: false)
        }
        
        notificationContent.sound = UNNotificationSound.default
                
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: delayTimeTrigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let state = UIApplication.shared.applicationState
        if state == .active {
            center.removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
            completionHandler([])
            return
        }
        
        print("Notification is about to be presented")
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .banner])
        } else {
            // Fallback on earlier versions
            completionHandler([.sound, .alert])
        }
    }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.actionIdentifier
        
        switch identifier {
        case UNNotificationDefaultActionIdentifier:
            print("The notification was dismissed")
            completionHandler()
            
        case UNNotificationDefaultActionIdentifier:
            print("The user opened the app for notification")
            completionHandler()
        default:
            print("default case was called")
            completionHandler()
        }
    }
}
