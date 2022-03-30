//
//  TimerNotificationsApp.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

@main
struct TimerNotificationsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environmentObject(NotificationManager.shared)
        }
    }
}
