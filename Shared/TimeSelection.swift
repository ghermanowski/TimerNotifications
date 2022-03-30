//
//  TimeSelection.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct TimeSelection: View {
	@State private var date = Date.now
	
    var body: some View {
		DatePicker(selection: $date, displayedComponents: .hourAndMinute) {
			Button("Remind me at") {
				
			}
			.buttonStyle(.compact)
		}
		.padding(8)
		.background(Color(uiColor: .secondarySystemGroupedBackground))
		.clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct TimeSelection_Previews: PreviewProvider {
    static var previews: some View {
        TimeSelection()
    }
}
