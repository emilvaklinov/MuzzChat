//
//  Message.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let timestamp: Date
    let isSentByUser: Bool
    
    init(id: UUID = UUID(), text: String, timestamp: Date = Date(), isSentByUser: Bool) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.isSentByUser = isSentByUser
    }
}

// MARK: - Message Grouping Logic
extension Message {
    /// Determines if this message should show a timestamp section header
    func shouldShowTimestamp(comparedTo previousMessage: Message?) -> Bool {
        guard let previous = previousMessage else { return true }
        
        let timeDifference = timestamp.timeIntervalSince(previous.timestamp)
        // Show timestamp if messages are more than 1 hour apart
        return abs(timeDifference) > 3600
    }
    
    /// Determines if this message should be grouped closely with the previous one
    func shouldGroupWith(previousMessage: Message?) -> Bool {
        guard let previous = previousMessage else { return false }
        
        // Only group messages from the same sender
        guard previous.isSentByUser == isSentByUser else { return false }
        
        let timeDifference = timestamp.timeIntervalSince(previous.timestamp)
        // Group if messages are within 20 seconds
        return abs(timeDifference) <= 20
    }
    
    /// Check if this is a system message (like "You matched")
    var isSystemMessage: Bool {
        text.contains("You matched") || text.contains("matched 🌹")
    }
    
    /// Check if message contains only emoji(s) - no background needed
    var isEmojiOnly: Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }
        
        // Check if all characters are emoji
        return trimmed.unicodeScalars.allSatisfy { scalar in
            scalar.properties.isEmoji && scalar.properties.isEmojiPresentation
        }
    }
}
