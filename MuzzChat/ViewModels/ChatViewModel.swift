//
//  ChatViewModel.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import Foundation
import CoreData
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var animatingMessageId: UUID?
    
    private let viewContext: NSManagedObjectContext
    private var cancellables = Set<AnyCancellable>()
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchMessages()
    }
    
    // MARK: - Fetch Messages
    func fetchMessages() {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.timestamp, ascending: true)]
        
        do {
            let entities = try viewContext.fetch(request)
            messages = entities.map { entity in
                Message(
                    id: entity.id ?? UUID(),
                    text: entity.text ?? "",
                    timestamp: entity.timestamp ?? Date(),
                    isSentByUser: entity.isSentByUser
                )
            }
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    // MARK: - Send Message
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let messageText = inputText
        inputText = ""
        
        let newMessage = Message(
            text: messageText,
            timestamp: Date(),
            isSentByUser: true
        )
        
        // Save to Core Data
        saveMessage(newMessage)
        
        // Add to local array with animation
        animatingMessageId = newMessage.id
        messages.append(newMessage)
        
        // Clear animation state after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animatingMessageId = nil
        }
    }
    
    // MARK: - Persistence
    private func saveMessage(_ message: Message) {
        let entity = MessageEntity(context: viewContext)
        entity.id = message.id
        entity.text = message.text
        entity.timestamp = message.timestamp
        entity.isSentByUser = message.isSentByUser
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save message: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    func shouldShowTimestamp(for message: Message, at index: Int) -> Bool {
        guard index > 0 else { return true }
        let previousMessage = messages[index - 1]
        return message.shouldShowTimestamp(comparedTo: previousMessage)
    }
    
    func shouldGroupMessage(at index: Int) -> Bool {
        guard index > 0 else { return false }
        let previousMessage = messages[index - 1]
        return messages[index].shouldGroupWith(previousMessage: previousMessage)
    }
    
    func formatTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today \(formatTime(date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday \(formatTime(date))"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, yyyy h:mm a"
            return formatter.string(from: date)
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}
