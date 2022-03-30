//
//  BigStyle.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct BigStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.font(.title3.weight(.semibold))
			.foregroundColor(.black)
			.padding(.vertical)
			.frame(maxWidth: .infinity)
			.background(Color.accentColor)
			.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
			.scaleEffect(configuration.isPressed ? 0.85 : 1)
			.opacity(configuration.isPressed ? 0.85 : 1)
	}
}

extension ButtonStyle where Self == BigStyle {
	static var big: BigStyle { BigStyle() }
}

struct BigStyle_Previews: PreviewProvider {
    static var previews: some View {
		if let abbreviatedInterval = TimeInterval(180).abbreviated {
			Button(abbreviatedInterval) { }
				.buttonStyle(.big)
		}
    }
}
