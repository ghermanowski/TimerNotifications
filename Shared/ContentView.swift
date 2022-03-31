//
//  ContentView.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var notificationManager: NotificationManager
	
	var inputFields: some View {
		VStack {
			InputField("Title", selection: $notificationManager.title)
			
			if !notificationManager.title.isEmpty {
				InputField("Subtitle", selection: $notificationManager.subtitle)
				
				InputField("Body", selection: $notificationManager.body)
			}
		}
		.padding(8)
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
	}
	
    var body: some View {
		NavigationView {
			if notificationManager.hasRequestedPermission {
				ScrollView {
					LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
						inputFields
							.padding(.bottom, 32)
						
						if !notificationManager.title.isEmpty {
							Section {
								TimeSelection()
									.padding(.bottom, 32)
							} header: {
								Header("Remind me at a time")
							}
							
							Section {
								TimePresets()
									.padding(.bottom, 32)
							} header: {
								Header("Remind me in")
							}
						} else if let pendingNotifications = notificationManager.pendingNotifications,
								  !pendingNotifications.isEmpty {
							PendingNotifications(pendingNotifications)
						}
						
					}
					.padding(.horizontal)
				}
				.navigationTitle("Notifications")
				.animation(.default, value: notificationManager.title.isEmpty)
				.task {
					await notificationManager.fetchPendingNotifications()
				}
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
		.navigationViewStyle(.stack)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
