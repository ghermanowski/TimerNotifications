//
//  TimePresets.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import Foundation
import SwiftUI

struct TimePresets: View {
	@EnvironmentObject private var notificationManager: NotificationManager
	
	private let intervals: [TimeInterval] = [5, 15, 60, 180, 300, 420, 600, 900, 1800, 2700, 3600, 5400]
	
	var body: some View {
		LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
			ForEach(intervals, id: \.self) { interval in
				if let abbreviatedInterval = interval.abbreviated {
					Button(abbreviatedInterval) {
						Task {
							await notificationManager.sendNotification(in: interval)
						}
					}
					.buttonStyle(.big)
				}
			}
		}
		.padding(8)
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
	}
}

struct TimePresets_Previews: PreviewProvider {
	static var previews: some View {
		TimePresets()
	}
}
