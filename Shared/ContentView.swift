//
//  ContentView.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var notificationManager: NotificationManager
	
    var body: some View {
		NavigationView {
			if notificationManager.hasRequestedPermission {
				ScrollView {
					LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
						Section {
							TimeSelection()
								.padding(.bottom, 32)
						} header: {
							Header("Remind me at a time")
						}
						
						Section {
							TimePresets()
						} header: {
							Header("Remind me in")
						}
					}
					.padding(.horizontal)
				}
				.navigationTitle("Reminders")
			} else {
				Button("Request Notification Permission") {
					Task {
						await notificationManager.requestPermission()
					}
				}
				.buttonStyle(.big)
				.padding(.horizontal)
			}
		}
		.background(Color(uiColor: .systemGroupedBackground))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
