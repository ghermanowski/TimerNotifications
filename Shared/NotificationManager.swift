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
	
	static func createContent() -> UNMutableNotificationContent {
		let content = UNMutableNotificationContent()
		content.sound = .default
		return content
	}
	
	private init() {
		content = Self.createContent()
	}
	
	private let notificationCentre = UNUserNotificationCenter.current()
	
	@AppStorage("hasRequestedPermission") private(set) var hasRequestedPermission = false
	
	@Published var content: UNMutableNotificationContent
	
	@Published private(set) var pendingNotifications: [UNNotificationRequest]?
	
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
		await scheduleNotification(trigger: trigger)
	}
	
	func sendNotification(at date: Date) async {
		let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		await scheduleNotification(trigger: trigger)
	}
	
	private func scheduleNotification(trigger: UNNotificationTrigger) async {
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
		
		do {
			try await notificationCentre.add(request)
			self.content = Self.createContent()
		} catch {
			print(error)
		}
		
		await fetchPendingNotifications()
	}
	
	func fetchPendingNotifications() async {
		pendingNotifications = await notificationCentre.pendingNotificationRequests()
	}
	
	func remove(_ notification: UNNotificationRequest) async {
		notificationCentre.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
		await fetchPendingNotifications()
	}
}
