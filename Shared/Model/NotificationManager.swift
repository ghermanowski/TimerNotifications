//
//  NotificationManager.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import Foundation
import UserNotifications
import SwiftUI

/// Handles all communication with the system notification centre.
@MainActor final class NotificationManager: ObservableObject {
	static let defaultCategoryID = "DEFAULT_CATEGORY"
	
	static let deleteActionID = "DELETE_ACTION"
	static let inputActionID = "INPUT_ACTION"
	static let repeatActionID = "REPEAT_ACTION"

	static let shared = NotificationManager()
	
	/// Return new notification content preconfigured with sound.
	static func createContent() -> UNMutableNotificationContent {
		let content = UNMutableNotificationContent()
		content.sound = .default
		content.categoryIdentifier = defaultCategoryID
		return content
	}
	
	static func setNotificationCategory() {
		let inputAction = UNTextInputNotificationAction(
			identifier: inputActionID,
			title: "Input text",
			icon: .init(systemImageName: "pencil"),
			textInputButtonTitle: "Done",
			textInputPlaceholder: "Write something"
		)
		
		let repeatAction = UNNotificationAction(
			identifier: repeatActionID,
			title: "Repeat",
			icon: .init(systemImageName: "repeat")
		)
		
		let deleteAction = UNNotificationAction(
			identifier: deleteActionID,
			title: "Delete",
			options: .destructive,
			icon: .init(systemImageName: "trash")
		)
		
		let defaultCategory = UNNotificationCategory(
			identifier: defaultCategoryID,
			actions: [inputAction, repeatAction, deleteAction],
			intentIdentifiers: [],
			hiddenPreviewsBodyPlaceholder: "Unlock to see.",
			options: .customDismissAction
		)
		
		UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
	}
	
	private init() {
		content = Self.createContent()
		Self.setNotificationCategory()
	}
	
	let notificationCentre = UNUserNotificationCenter.current()
	
	@AppStorage("hasRequestedPermission") private(set) var hasRequestedPermission = false
	
	// Instead of creating separate variable for title, body and notes, this variable stores
	// all three and is later used to create the requests.
	@Published var content: UNMutableNotificationContent
	
	@Published private(set) var pendingNotifications: [UNNotificationRequest]?
	
	// This method is not used as it is async and does not work in SwiftUI View Bodies.
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
	
	/// Schedules a request to send a notification after the selected interval.
	/// - Parameter timeInterval: Interval until the notification is triggered.
	func sendNotification(in timeInterval: TimeInterval) async {
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
		await scheduleNotification(trigger: trigger)
	}
	
	/// Schedules a request to send a notification at the selected date.
	/// - Parameter date: Date at which the notification is triggered.
	func sendNotification(at date: Date) async {
		let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		await scheduleNotification(trigger: trigger)
	}
	
	/// Uses the instance variable content to add a notification request.
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
	
	/// Deschedules the selected notification request.
	func remove(_ notification: UNNotificationRequest) async {
		notificationCentre.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
		await fetchPendingNotifications()
	}
}
