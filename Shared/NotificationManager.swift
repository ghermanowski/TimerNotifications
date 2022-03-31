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
	
	@Published var pendingNotifications: [UNNotificationRequest]?
	
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
	
	func sendNotification(in timeInterval: TimeInterval) async {
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
		await scheduleNotification(content: createNotification(), trigger: trigger)
	}
	
	func sendNotification(at date: Date) async {
		let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		await scheduleNotification(content: createNotification(), trigger: trigger)
	}
	
	private func scheduleNotification(content: UNMutableNotificationContent,
									  trigger: UNNotificationTrigger) async {
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		
		do {
			try await notificationCentre.add(request)
		} catch {
			print(error)
		}
		
		await fetchPendingNotifications()
	}
	
	private func createNotification() -> UNMutableNotificationContent {
		let content = UNMutableNotificationContent()
		content.title = title
		content.subtitle = subtitle
		content.body = body
		content.sound = .default
		title = ""
		subtitle = ""
		body = ""
		return content
	}
	
	func fetchPendingNotifications() async {
		pendingNotifications = await notificationCentre.pendingNotificationRequests()
	}
}
