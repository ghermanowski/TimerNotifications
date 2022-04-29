//
//  AppDelegate.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 29. April 2022.
//

import Foundation
import UIKit

// Sources: https://createwithswift.com/notifications-tutorial-user-interaction-with-notifications-with-async-await
// https://developer.apple.com/documentation/usernotifications/handling_notifications_and_notification-related_actions

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		NotificationManager.shared.notificationCentre.delegate = self
		return true
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
		let notificationRequest = response.notification.request
		let categoryIdentifier = notificationRequest.content.categoryIdentifier
		let actionIdentifier = response.actionIdentifier
		
		if categoryIdentifier == NotificationManager.defaultCategoryID {
			switch actionIdentifier {
				case NotificationManager.deleteActionID:
					await NotificationManager.shared.remove(notificationRequest)
				case NotificationManager.repeatActionID: break
				default: break
			}
		}
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
		if notification.request.content.categoryIdentifier == NotificationManager.defaultCategoryID {
			return [.badge, .banner, .list, .sound]
		} else {
			return UNNotificationPresentationOptions(rawValue: 0)
		}
	}
}
