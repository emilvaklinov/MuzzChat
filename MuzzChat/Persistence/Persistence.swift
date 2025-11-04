//
//  Persistence.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MuzzChat")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if !inMemory {
            seedDataIfNeeded()
        }
    }
    
    // MARK: - Seed Data
    private func seedDataIfNeeded() {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        
        do {
            let count = try container.viewContext.count(for: fetchRequest)
            
            // Only seed if database is empty
            if count == 0 {
                let now = Date()
                let sampleMessages = [
                    ("You matched 🌹", false, now.addingTimeInterval(-86400 * 300)), // ~300 days ago
                    ("Hey! Did you also go to Oxford?", false, now.addingTimeInterval(-60)),
                    ("Yes 😎 Are you going to the food festival on Sunday?", true, now.addingTimeInterval(-50)),
                    ("🙏", false, now.addingTimeInterval(-30)),
                    ("I am! 😊 See you there for a coffee?", false, now.addingTimeInterval(-20))
                ]
                
                for (text, isSent, date) in sampleMessages {
                    let message = MessageEntity(context: container.viewContext)
                    message.id = UUID()
                    message.text = text
                    message.timestamp = date
                    message.isSentByUser = isSent
                }
                
                try container.viewContext.save()
            }
        } catch {
            print("Failed to seed data: \(error)")
        }
    }
    
    // MARK: - Preview Support
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let now = Date()
        let sampleMessages = [
            ("You matched 🌹", false, now.addingTimeInterval(-86400 * 300)), // ~300 days ago (Jan 7, 2020)
            ("Hey! Did you also go to Oxford?", false, now.addingTimeInterval(-60)),
            ("Yes 😎 Are you going to the food festival on Sunday?", true, now.addingTimeInterval(-50)),
            ("🙏", false, now.addingTimeInterval(-30)),
            ("I am! 😊 See you there for a coffee?", false, now.addingTimeInterval(-20))
        ]
        
        for (text, isSent, date) in sampleMessages {
            let message = MessageEntity(context: viewContext)
            message.id = UUID()
            message.text = text
            message.timestamp = date
            message.isSentByUser = isSent
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to create preview data: \(error)")
        }
        
        return controller
    }()
}
