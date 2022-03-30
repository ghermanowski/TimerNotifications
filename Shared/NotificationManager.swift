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
	@Published var content = ""
	
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
}
