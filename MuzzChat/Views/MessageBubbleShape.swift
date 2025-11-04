//
//  MessageBubbleShape.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 04/11/2025.
//

import SwiftUI

struct MessageBubbleShape: Shape {
    var isUserSent: Bool
    var hasGroupedMessage: Bool
    
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 18
        let tailSize: CGFloat = 6
        
        var path = Path()
        
        if isUserSent {
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(0),
                       clockwise: false)
            
            if hasGroupedMessage {
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
                path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                           radius: radius,
                           startAngle: .degrees(0),
                           endAngle: .degrees(90),
                           clockwise: false)
            } else {
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius - tailSize))
                path.addQuadCurve(
                    to: CGPoint(x: rect.maxX - radius, y: rect.maxY),
                    control: CGPoint(x: rect.maxX + tailSize, y: rect.maxY - tailSize)
                )
            }
            
            path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: .degrees(90),
                       endAngle: .degrees(180),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
        } else {
            path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(-90),
                       endAngle: .degrees(0),
                       clockwise: false)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
            path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                       radius: radius,
                       startAngle: .degrees(0),
                       endAngle: .degrees(90),
                       clockwise: false)
            
            if hasGroupedMessage {
                path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
                path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                           radius: radius,
                           startAngle: .degrees(90),
                           endAngle: .degrees(180),
                           clockwise: false)
            } else {
                path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
                path.addQuadCurve(
                    to: CGPoint(x: rect.minX, y: rect.maxY - radius - tailSize),
                    control: CGPoint(x: rect.minX - tailSize, y: rect.maxY - tailSize)
                )
            }
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
            path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                       radius: radius,
                       startAngle: .degrees(180),
                       endAngle: .degrees(270),
                       clockwise: false)
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Preview
struct MessageBubbleShape_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MessageBubbleShape(isUserSent: true, hasGroupedMessage: false)
                .fill(Color(red: 0.95, green: 0.35, blue: 0.45))
                .frame(width: 200, height: 60)
            
            MessageBubbleShape(isUserSent: false, hasGroupedMessage: false)
                .fill(Color(.systemGray5))
                .frame(width: 200, height: 60)
            
            MessageBubbleShape(isUserSent: true, hasGroupedMessage: true)
                .fill(Color(red: 0.95, green: 0.35, blue: 0.45))
                .frame(width: 200, height: 60)
        }
        .padding()
    }
}
