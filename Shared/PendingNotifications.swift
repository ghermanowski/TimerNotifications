//
//  PendingNotifications.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 31. March 2022.
//

import SwiftUI

struct PendingNotifications: View {
	internal init(_ notifications: [UNNotificationRequest]) {
		self.notifications = notifications.sorted { left, right in
			guard let leftDate = (left.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ??
			(left.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate() else {
				let rightDate = (right.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ??
				(right.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate()
				
				return rightDate != nil
			}
			
			guard let rightDate = (right.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate() ??
					(right.trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate() else {
				return true
			}
			
			return leftDate < rightDate
		}
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
