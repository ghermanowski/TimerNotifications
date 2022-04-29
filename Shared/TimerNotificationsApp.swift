//
//  TimerNotificationsApp.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import Foundation
import SwiftUI

@main
struct TimerNotificationsApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(NotificationManager.shared)
        }
    }
}
