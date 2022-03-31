//
//  NotificationItem.swift
//  TimerNotifications (iOS)
//
//  Created by Gregor Hermanowski on 31. March 2022.
//

import SwiftUI

struct NotificationItem: View {
	internal init(_ notification: UNNotificationRequest) {
		self.notification = notification
	}
	
	private let notification: UNNotificationRequest
	
    var body: some View {
		HStack(alignment: .firstTextBaseline) {
			Image(systemName: "star.fill")
			
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
		.padding()
		.background(Color(uiColor: .tertiarySystemFill))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
		.overlay(alignment: .topTrailing) {
			Group {
				if let timeTrigger = notification.trigger as? UNCalendarNotificationTrigger,
				   let date = timeTrigger.nextTriggerDate() {
					Text("at \(date, style: .time)")
				} else if let intervalTrigger = notification.trigger as? UNTimeIntervalNotificationTrigger,
						  let date = intervalTrigger.nextTriggerDate() {
					Text("in \(date, style: .timer)")
				}
			}
			.padding()
		}
    }
}

//struct NotificationItem_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationItem()
//    }
//}
