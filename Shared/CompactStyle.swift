//
//  CompactStyle.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct CompactStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.title3.weight(.semibold))
			.foregroundColor(.black)
			.padding(.vertical, 6)
			.padding(.horizontal, 10)
			.background(Color.accentColor)
			.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
			.scaleEffect(configuration.isPressed ? 0.85 : 1)
			.opacity(configuration.isPressed ? 0.85 : 1)
	}
}

extension ButtonStyle where Self == CompactStyle {
	static var compact: CompactStyle { CompactStyle() }
}

struct CompactStyle_Previews: PreviewProvider {
	static var previews: some View {
		Button("Button Title") { }
			.buttonStyle(.compact)
	}
}
