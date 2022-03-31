//
//  Header.swift
//  TimerNotifications
//
//  Created by Gregor Hermanowski on 30. March 2022.
//

import SwiftUI

struct Header: View {
	internal init(_ title: String) {
		self.title = title
	}
	
	private let title: String
	
    var body: some View {
        Text(title)
			.font(.title3.weight(.semibold))
			.padding([.leading, .vertical], 8)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(Color(uiColor: .systemGroupedBackground))
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header("Header Title")
    }
}
