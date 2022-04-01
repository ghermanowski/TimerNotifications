//
//  UNNotificationRequest.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 31. March 2022.
//

import Foundation
import UserNotifications

extension UNNotificationRequest: Comparable {
	public static func < (left: UNNotificationRequest, right: UNNotificationRequest) -> Bool {
		guard let leftDate = left.triggerDate else { return right.triggerDate != nil }
		guard let rightDate = right.triggerDate else { return true }
		return leftDate < rightDate
	}
	
	var triggerDate: Date? {
		calendarTriggerDate ?? intervalTriggerDate
	}
	
	var calendarTriggerDate: Date? {
		(trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
	}
	
	var intervalTriggerDate: Date? {
		(trigger as? UNTimeIntervalNotificationTrigger)?.nextTriggerDate()
	}
}
