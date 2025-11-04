//
//  MessageBubbleView.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isGrouped: Bool
    let isAnimating: Bool
    var showTail: Bool = true
    
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isSentByUser {
                Spacer(minLength: 50)
                
                messageBubble
                    .scaleEffect(isAnimating ? scale : 1.0)
                    .opacity(isAnimating ? opacity : 1.0)
            } else {
                
                messageBubble
                
                Spacer(minLength: 50)
            }
        }
        .padding(.vertical, isGrouped ? 3 : 8)
        .onAppear {
            if isAnimating {
                // iMessage-style animation
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
    }
    
    private var messageBubble: some View {
        Group {
            if message.isEmojiOnly {
                Text(message.text)
                    .font(.system(size: 48))
            } else {
                HStack(alignment: .bottom, spacing: 6) {
                    Text(message.text)
                        .font(.system(size: 16))
                        .foregroundColor(message.isSentByUser ? .white : Color(.label))
                    
                    if message.isSentByUser {
                        ZStack(alignment: .leading) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(.white)
                                .offset(x: 0)
                            Image(systemName: "checkmark")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(.white)
                                .offset(x: 3)
                        }
                        .frame(width: 16, height: 12)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    CustomRoundedCorner(
                        topLeft: 20,
                        topRight: 20,
                        bottomLeft: message.isSentByUser ? 20 : 4,
                        bottomRight: message.isSentByUser ? 4 : 20
                    )
                    .fill(message.isSentByUser ?
                          Color(red: 0.95, green: 0.35, blue: 0.45) :
                          Color(.systemGray5))
                )
            }
        }
    }
}

// MARK: - Preview
struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            MessageBubbleView(
                message: Message(text: "Hey! Did you also go to Oxford?", isSentByUser: false),
                isGrouped: false,
                isAnimating: false
            )
            
            MessageBubbleView(
                message: Message(text: "Yes 😎 Are you going to the food festival on Sunday?", isSentByUser: true),
                isGrouped: false,
                isAnimating: false
            )
            
            MessageBubbleView(
                message: Message(text: "I am! 😊 See you there for a coffee?", isSentByUser: false),
                isGrouped: true,
                isAnimating: false
            )
        }
        .padding()
    }
}
