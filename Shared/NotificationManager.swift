//
//  NotificationManager.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import Foundation
import UserNotifications
import SwiftUI

@MainActor final class NotificationManager: ObservableObject {
	static let shared = NotificationManager()
	
	private init() { }
	
	let notificationCentre = UNUserNotificationCenter.current()
	
	@AppStorage("hasRequestedPermission") private(set) var hasRequestedPermission = false
	
	@Published var title = ""
	@Published var subtitle = ""
	@Published var body = ""
	
	func canSendNotfications() async -> Bool {
		let settings = await notificationCentre.notificationSettings()
		return settings.authorizationStatus == .authorized
	}
	
	func requestPermission() async {
		do {
			try await notificationCentre.requestAuthorization(options: [.alert, .badge, .sound])
		} catch {
			print(error)
		}
		
		hasRequestedPermission = true
	}
	
	func sendNotification(in timeInterval: TimeInterval) {
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
		let content = createNotification()
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		notificationCentre.add(request)
	}
	
	private func createNotification() -> UNMutableNotificationContent {
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = subtitle
		content.body = body
		content.sound = UNNotificationSound.default
		title = ""
		subtitle = ""
		body = ""
		return content
	}
}
