//
//  InputField.swift
//  TimerNotifications (iOS)
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct InputField: View {
	init(_ label: String, selection title: Binding<String>) {
		self._title = title
		self.label = label
	}
	
	private let label: String
	
	@Binding private var title: String
    
	var body: some View {
		TextField(label, text: $title)
			.padding(8)
			.padding(.horizontal, 8)
			.background(Color(uiColor: .tertiarySystemFill))
			.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct InputField_Previews: PreviewProvider {
	@State static var title = ""
	
    static var previews: some View {
		InputField("Field Title", selection: $title)
    }
}
