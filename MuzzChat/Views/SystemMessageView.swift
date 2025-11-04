//
//  SystemMessageView.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI

struct SystemMessageView: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(.label))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

// MARK: - Preview
struct SystemMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SystemMessageView(text: "You matched 🌹")
    }
}
