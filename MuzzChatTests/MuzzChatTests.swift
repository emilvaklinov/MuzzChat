//
//  MuzzChatTests.swift
//  MuzzChatTests
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import XCTest
@testable import MuzzChat

final class MessageTests: XCTestCase {
    
    // MARK: - Timestamp Section Tests
    
    func testShouldShowTimestamp_WhenNoPreviousMessage() {
        let message = Message(text: "Hello", isSentByUser: true)
        
        XCTAssertTrue(message.shouldShowTimestamp(comparedTo: nil))
    }
    
    func testShouldShowTimestamp_WhenMoreThanOneHourApart() {
        let now = Date()
        let oneHourAgo = now.addingTimeInterval(-3601) // 1 hour + 1 second
        
        let previousMessage = Message(text: "Old", timestamp: oneHourAgo, isSentByUser: false)
        let currentMessage = Message(text: "New", timestamp: now, isSentByUser: true)
        
        XCTAssertTrue(currentMessage.shouldShowTimestamp(comparedTo: previousMessage))
    }
    
    func testShouldNotShowTimestamp_WhenLessThanOneHourApart() {
        let now = Date()
        let thirtyMinutesAgo = now.addingTimeInterval(-1800) // 30 minutes
        
        let previousMessage = Message(text: "Recent", timestamp: thirtyMinutesAgo, isSentByUser: false)
        let currentMessage = Message(text: "New", timestamp: now, isSentByUser: true)
        
        XCTAssertFalse(currentMessage.shouldShowTimestamp(comparedTo: previousMessage))
    }
    
    // MARK: - Message Grouping Tests
    
    func testShouldNotGroup_WhenNoPreviousMessage() {
        let message = Message(text: "Hello", isSentByUser: true)
        
        XCTAssertFalse(message.shouldGroupWith(previousMessage: nil))
    }
    
    func testShouldNotGroup_WhenDifferentSenders() {
        let now = Date()
        let fiveSecondsAgo = now.addingTimeInterval(-5)
        
        let previousMessage = Message(text: "From them", timestamp: fiveSecondsAgo, isSentByUser: false)
        let currentMessage = Message(text: "From me", timestamp: now, isSentByUser: true)
        
        XCTAssertFalse(currentMessage.shouldGroupWith(previousMessage: previousMessage))
    }
    
    func testShouldGroup_WhenSameSenderWithin20Seconds() {
        let now = Date()
        let tenSecondsAgo = now.addingTimeInterval(-10)
        
        let previousMessage = Message(text: "First", timestamp: tenSecondsAgo, isSentByUser: true)
        let currentMessage = Message(text: "Second", timestamp: now, isSentByUser: true)
        
        XCTAssertTrue(currentMessage.shouldGroupWith(previousMessage: previousMessage))
    }
    
    func testShouldNotGroup_WhenSameSenderMoreThan20SecondsApart() {
        let now = Date()
        let thirtySecondsAgo = now.addingTimeInterval(-30)
        
        let previousMessage = Message(text: "First", timestamp: thirtySecondsAgo, isSentByUser: true)
        let currentMessage = Message(text: "Second", timestamp: now, isSentByUser: true)
        
        XCTAssertFalse(currentMessage.shouldGroupWith(previousMessage: previousMessage))
    }
    
    func testShouldGroup_WhenExactly20SecondsApart() {
        let now = Date()
        let twentySecondsAgo = now.addingTimeInterval(-20)
        
        let previousMessage = Message(text: "First", timestamp: twentySecondsAgo, isSentByUser: true)
        let currentMessage = Message(text: "Second", timestamp: now, isSentByUser: true)
        
        XCTAssertTrue(currentMessage.shouldGroupWith(previousMessage: previousMessage))
    }
    
    // MARK: - System Message Tests
    
    func testIsSystemMessage_WhenContainsYouMatched() {
        let message = Message(text: "You matched 🌹", isSentByUser: false)
        
        XCTAssertTrue(message.isSystemMessage)
    }
    
    func testIsSystemMessage_WhenContainsMatchedWithRose() {
        let message = Message(text: "You matched 🌹 with Alisha", isSentByUser: false)
        
        XCTAssertTrue(message.isSystemMessage)
    }
    
    func testIsNotSystemMessage_WhenRegularMessage() {
        let message = Message(text: "Hello there!", isSentByUser: true)
        
        XCTAssertFalse(message.isSystemMessage)
    }
    
    // MARK: - Emoji Only Tests
    
    func testIsEmojiOnly_WithSingleEmoji() {
        let message = Message(text: "🙏", isSentByUser: false)
        
        XCTAssertTrue(message.isEmojiOnly)
    }
    
    func testIsEmojiOnly_WithMultipleEmojis() {
        let message = Message(text: "😊🎉", isSentByUser: true)
        
        XCTAssertTrue(message.isEmojiOnly)
    }
    
    func testIsNotEmojiOnly_WithTextAndEmoji() {
        let message = Message(text: "Hello 😊", isSentByUser: true)
        
        XCTAssertFalse(message.isEmojiOnly)
    }
    
    func testIsNotEmojiOnly_WithOnlyText() {
        let message = Message(text: "Hello", isSentByUser: true)
        
        XCTAssertFalse(message.isEmojiOnly)
    }
    
    func testIsNotEmojiOnly_WithEmptyString() {
        let message = Message(text: "", isSentByUser: true)
        
        XCTAssertFalse(message.isEmojiOnly)
    }
    
    func testIsNotEmojiOnly_WithWhitespace() {
        let message = Message(text: "   ", isSentByUser: true)
        
        XCTAssertFalse(message.isEmojiOnly)
    }
    
    // MARK: - Message Equality Tests
    
    func testMessageEquality_WhenSameId() {
        let id = UUID()
        let message1 = Message(id: id, text: "Hello", isSentByUser: true)
        let message2 = Message(id: id, text: "Hello", isSentByUser: true)
        
        XCTAssertEqual(message1, message2)
    }
    
    func testMessageInequality_WhenDifferentId() {
        let message1 = Message(text: "Hello", isSentByUser: true)
        let message2 = Message(text: "Hello", isSentByUser: true)
        
        XCTAssertNotEqual(message1, message2)
    }
}
