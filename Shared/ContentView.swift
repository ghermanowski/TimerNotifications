//
//  ContentView.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var notificationManager: NotificationManager
	
	@FocusState private var focusedField: AnyKeyPath?
	
	var inputFields: some View {
		VStack {
			InputField("Title", selection: $notificationManager.content.title)
				.focused($focusedField, equals: \UNMutableNotificationContent.title)
			
			if !notificationManager.content.title.isEmpty ||
				!notificationManager.content.subtitle.isEmpty ||
				!notificationManager.content.body.isEmpty ||
				focusedField == \UNMutableNotificationContent.subtitle ||
				focusedField == \UNMutableNotificationContent.body {
				InputField("Subtitle", selection: $notificationManager.content.subtitle)
					.focused($focusedField, equals: \UNMutableNotificationContent.subtitle)
				
				InputField("Body", selection: $notificationManager.content.body)
					.focused($focusedField, equals: \UNMutableNotificationContent.body)
			}
		}
		.padding(8)
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
	}
	
	// IDEA: Repeating preset pomodoro
	
    var body: some View {
		NavigationView {
			if notificationManager.hasRequestedPermission {
				ScrollView {
					LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
						inputFields
							.padding(.bottom, 32)
						
						if !notificationManager.content.title.isEmpty {
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
						} else if focusedField == nil,
								  let pendingNotifications = notificationManager.pendingNotifications,
								  !pendingNotifications.isEmpty {
							PendingNotifications(pendingNotifications)
						}
						
					}
					.padding(.horizontal)
					.onChange(of: notificationManager.content) { _ in
						focusedField = nil
					}
				}
				.navigationTitle("Notifications")
				.animation(.default, value: notificationManager.content.title.isEmpty)
				.animation(.default, value: focusedField)
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
