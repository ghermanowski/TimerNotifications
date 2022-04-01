//
//  PendingNotifications.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 31. March 2022.
//

import SwiftUI

struct PendingNotifications: View {
	internal init(_ notifications: [UNNotificationRequest]) {
		self.notifications = notifications.sorted()
	}
	
	private let notifications: [UNNotificationRequest]
	
	var body: some View {
		LazyVStack(spacing: 8) {
			ForEach(notifications, id: \.identifier) { notification in
				NotificationItem(notification)
			}
		}
	}
}

struct PendingNotifications_Previews: PreviewProvider {
	static var previews: some View {
        PendingNotifications([])
    }
}
