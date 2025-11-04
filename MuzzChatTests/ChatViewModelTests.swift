//
//  ChatViewModelTests.swift
//  MuzzChatTests
//
//  Created by Emil Vaklinov on 04/11/2025.
//

import XCTest
import CoreData
import Combine
@testable import MuzzChat

final class ChatViewModelTests: XCTestCase {
    var viewModel: ChatViewModel!
    var testContext: NSManagedObjectContext!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        // Create in-memory Core Data stack for testing
        let persistenceController = PersistenceController(inMemory: true)
        testContext = persistenceController.container.viewContext
        
        viewModel = ChatViewModel(viewContext: testContext)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        testContext = nil
        cancellables = nil
    }
    
    // MARK: - Send Message Tests
    
    func testSendMessage_AddsMessageToList() {
        viewModel.inputText = "Test message"
        let initialCount = viewModel.messages.count
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.messages.count, initialCount + 1)
        XCTAssertEqual(viewModel.messages.last?.text, "Test message")
        XCTAssertTrue(viewModel.messages.last?.isSentByUser ?? false)
    }
    
    func testSendMessage_ClearsInputText() {
        viewModel.inputText = "Test message"
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.inputText, "")
    }
    
    func testSendMessage_DoesNotSendEmptyMessage() {
        viewModel.inputText = ""
        let initialCount = viewModel.messages.count
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.messages.count, initialCount)
    }
    
    func testSendMessage_DoesNotSendWhitespaceOnlyMessage() {
        viewModel.inputText = "   "
        let initialCount = viewModel.messages.count
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.messages.count, initialCount)
    }
    
    func testSendMessage_TrimsWhitespace() {
        viewModel.inputText = "  Hello  "
        
        viewModel.sendMessage()
        
        XCTAssertEqual(viewModel.messages.last?.text, "Hello")
    }
    
    func testSendMessage_SetsAnimatingMessageId() {
        viewModel.inputText = "Test"
        
        viewModel.sendMessage()
        
        XCTAssertNotNil(viewModel.animatingMessageId)
        XCTAssertEqual(viewModel.animatingMessageId, viewModel.messages.last?.id)
    }
    
    // MARK: - Timestamp Tests
    
    func testShouldShowTimestamp_ForFirstMessage() {
        let message = Message(text: "First", isSentByUser: true)
        viewModel.messages = [message]
        
        XCTAssertTrue(viewModel.shouldShowTimestamp(for: message, at: 0))
    }
    
    func testShouldShowTimestamp_WhenMoreThanOneHourApart() {
        let now = Date()
        let twoHoursAgo = now.addingTimeInterval(-7200)
        
        let oldMessage = Message(text: "Old", timestamp: twoHoursAgo, isSentByUser: false)
        let newMessage = Message(text: "New", timestamp: now, isSentByUser: true)
        
        viewModel.messages = [oldMessage, newMessage]
        
        XCTAssertTrue(viewModel.shouldShowTimestamp(for: newMessage, at: 1))
    }
    
    func testShouldNotShowTimestamp_WhenLessThanOneHourApart() {
        let now = Date()
        let thirtyMinutesAgo = now.addingTimeInterval(-1800)
        
        let oldMessage = Message(text: "Recent", timestamp: thirtyMinutesAgo, isSentByUser: false)
        let newMessage = Message(text: "New", timestamp: now, isSentByUser: true)
        
        viewModel.messages = [oldMessage, newMessage]
        
        XCTAssertFalse(viewModel.shouldShowTimestamp(for: newMessage, at: 1))
    }
    
    // MARK: - Message Grouping Tests
    
    func testShouldNotGroupMessage_ForFirstMessage() {
        let message = Message(text: "First", isSentByUser: true)
        viewModel.messages = [message]
        
        XCTAssertFalse(viewModel.shouldGroupMessage(at: 0))
    }
    
    func testShouldGroupMessage_WhenSameSenderWithin20Seconds() {
        let now = Date()
        let tenSecondsAgo = now.addingTimeInterval(-10)
        
        let firstMessage = Message(text: "First", timestamp: tenSecondsAgo, isSentByUser: true)
        let secondMessage = Message(text: "Second", timestamp: now, isSentByUser: true)
        
        viewModel.messages = [firstMessage, secondMessage]
        
        XCTAssertTrue(viewModel.shouldGroupMessage(at: 1))
    }
    
    func testShouldNotGroupMessage_WhenDifferentSenders() {
        let now = Date()
        let fiveSecondsAgo = now.addingTimeInterval(-5)
        
        let receivedMessage = Message(text: "From them", timestamp: fiveSecondsAgo, isSentByUser: false)
        let sentMessage = Message(text: "From me", timestamp: now, isSentByUser: true)
        
        viewModel.messages = [receivedMessage, sentMessage]
        
        XCTAssertFalse(viewModel.shouldGroupMessage(at: 1))
    }
    
    func testShouldNotGroupMessage_WhenMoreThan20SecondsApart() {
        let now = Date()
        let thirtySecondsAgo = now.addingTimeInterval(-30)
        
        let firstMessage = Message(text: "First", timestamp: thirtySecondsAgo, isSentByUser: true)
        let secondMessage = Message(text: "Second", timestamp: now, isSentByUser: true)
        
        viewModel.messages = [firstMessage, secondMessage]
        
        XCTAssertFalse(viewModel.shouldGroupMessage(at: 1))
    }
    
    // MARK: - Timestamp Formatting Tests
    
    func testFormatTimestamp_Today() {
        let now = Date()
        let formatted = viewModel.formatTimestamp(now)
        
        // Should contain "Today" and a time
        XCTAssertTrue(formatted.contains("Today"))
    }
    
    func testFormatTimestamp_Yesterday() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let formatted = viewModel.formatTimestamp(yesterday)
        
        // Should contain "Yesterday" and a time
        XCTAssertTrue(formatted.contains("Yesterday"))
    }
    
    func testFormatTimestamp_OlderDate() {
        let threeDaysAgo = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        let formatted = viewModel.formatTimestamp(threeDaysAgo)
        
        // Should contain a date (not "Today" or "Yesterday")
        XCTAssertFalse(formatted.contains("Today"))
        XCTAssertFalse(formatted.contains("Yesterday"))
    }
    
    // MARK: - Fetch Messages Tests
    
    func testFetchMessages_LoadsFromCoreData() {
        // Create test message in Core Data
        let entity = MessageEntity(context: testContext)
        entity.id = UUID()
        entity.text = "Test message"
        entity.timestamp = Date()
        entity.isSentByUser = true
        
        try? testContext.save()
        
        viewModel.fetchMessages()
        
        XCTAssertGreaterThan(viewModel.messages.count, 0)
    }
    
    func testFetchMessages_SortsMessagesByTimestamp() {
        let now = Date()
        let earlier = now.addingTimeInterval(-100)
        
        // Create messages in reverse order
        let entity2 = MessageEntity(context: testContext)
        entity2.id = UUID()
        entity2.text = "Later"
        entity2.timestamp = now
        entity2.isSentByUser = true
        
        let entity1 = MessageEntity(context: testContext)
        entity1.id = UUID()
        entity1.text = "Earlier"
        entity1.timestamp = earlier
        entity1.isSentByUser = false
        
        try? testContext.save()
        
        viewModel.fetchMessages()
        
        // Should be sorted oldest first
        XCTAssertEqual(viewModel.messages.first?.text, "Earlier")
        XCTAssertEqual(viewModel.messages.last?.text, "Later")
    }
    
    // MARK: - Performance Tests
    
    func testSendMessagePerformance() {
        measure {
            viewModel.inputText = "Performance test message"
            viewModel.sendMessage()
        }
    }
    
    func testGroupingPerformanceWithManyMessages() {
        // Create 100 messages
        let now = Date()
        for i in 0..<100 {
            let timestamp = now.addingTimeInterval(Double(i * 10))
            let message = Message(text: "Message \(i)", timestamp: timestamp, isSentByUser: i % 2 == 0)
            viewModel.messages.append(message)
        }
        
        measure {
            for i in 0..<viewModel.messages.count {
                _ = viewModel.shouldGroupMessage(at: i)
            }
        }
    }
}
