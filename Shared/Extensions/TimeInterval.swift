//
//  TimeInterval.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import Foundation

extension TimeInterval {
	static let abbreviatedFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		return formatter
	}()
	
	var abbreviated: String? {
		Self.abbreviatedFormatter.string(from: self)
	}
}
