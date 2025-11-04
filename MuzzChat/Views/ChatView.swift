//
//  ChatView.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI
import CoreData

struct ChatView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ChatViewModel
    @State private var scrollProxy: ScrollViewProxy?
    
    init() {
        _viewModel = StateObject(wrappedValue: ChatViewModel(viewContext: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Color.clear.frame(height: 20)
                        
                        ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                            VStack(spacing: 0) {

                                if viewModel.shouldShowTimestamp(for: message, at: index) {
                                    TimestampView(text: viewModel.formatTimestamp(message.timestamp))
                                        .padding(.vertical, 16)
                                }
                                
                                if message.isSystemMessage {
                                    SystemMessageView(text: message.text)
                                        .id(message.id)
                                } else {
                                    MessageBubbleView(
                                        message: message,
                                        isGrouped: viewModel.shouldGroupMessage(at: index),
                                        isAnimating: viewModel.animatingMessageId == message.id
                                    )
                                    .id(message.id)
                                }
                            }
                        }
                        
                        Color.clear.frame(height: 8)
                    }
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    scrollProxy = proxy
                    scrollToBottom(proxy: proxy, animated: false)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom(proxy: proxy, animated: true)
                }
            }
            
            InputBarView(
                text: $viewModel.inputText,
                onSend: viewModel.sendMessage
            )
        }
        .background(Color(.systemBackground))
        .onAppear {
            if viewModel.messages.isEmpty {
                viewModel.fetchMessages()
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text("A")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        )
                    
                    Text("Alisha")
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Chat")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.4))
                    
                    Rectangle()
                        .fill(Color(red: 0.9, green: 0.3, blue: 0.4))
                        .frame(height: 2)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text("Profile")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    // MARK: - Helper Methods
    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool) {
        guard let lastMessage = viewModel.messages.last else { return }
        
        if animated {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        } else {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

// MARK: - Preview
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
