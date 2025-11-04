//
//  BubbleTail.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI

struct BubbleTail: Shape {
    var isUserSent: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if isUserSent {
            // Angular tail on bottom-right for sent messages
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.closeSubpath()
        } else {
            // Angular tail on bottom-left for received messages
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.closeSubpath()
        }
        
        return path
    }
}

// MARK: - Preview
struct BubbleTail_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            BubbleTail(isUserSent: true)
                .fill(Color(red: 0.95, green: 0.35, blue: 0.45))
                .frame(width: 10, height: 10)
            
            BubbleTail(isUserSent: false)
                .fill(Color(.systemGray5))
                .frame(width: 10, height: 10)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
