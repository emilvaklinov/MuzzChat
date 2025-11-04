//
//  TimestampView.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI

struct TimestampView: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color(.systemGray))
            Spacer()
        }
    }
}

// MARK: - Preview
struct TimestampView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            TimestampView(text: "Today 1:06 PM")
            TimestampView(text: "January 7, 2020 8:18 PM")
        }
        .padding()
    }
}
