//
//  NotificationItem.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 31. March 2022.
//

import Foundation
import SwiftUI

struct NotificationItem: View {
	internal init(_ notification: UNNotificationRequest) {
		self.notification = notification
	}
	
	@EnvironmentObject private var notificationManager: NotificationManager
	
	private let notification: UNNotificationRequest
	
    var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: "star.fill")
				.foregroundStyle(.tint)
			
			VStack(alignment: .leading, spacing: 6) {
				Text(notification.content.title)
					.font(.headline)
				
				if !notification.content.subtitle.isEmpty {
					Text(notification.content.subtitle)
						.font(.subheadline)
				}
				
				if !notification.content.body.isEmpty {
					Text(notification.content.body)
						.font(.footnote)
				}
			}
			
			Spacer()
		}
		.overlay(alignment: .topTrailing) {
			Group {
				if let calendarTriggerDate = notification.calendarTriggerDate {
					Text("at \(calendarTriggerDate, style: .time)")
				} else if let intervalTriggerDate = notification.intervalTriggerDate {
					Text("in \(intervalTriggerDate, style: .timer)")
				}
			}
			.foregroundStyle(.tint)
		}
		.padding()
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
		.contextMenu {
			Button(role: .destructive) {
				Task {
					await notificationManager.remove(notification)
				}
			} label: {
				Label("Remove Notification", systemImage: "xmark.circle")
			}
		}
    }
}

//struct NotificationItem_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationItem()
//    }
//}
