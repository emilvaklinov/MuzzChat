//
//  MuzzChatApp.swift
//  MuzzChat
//
//  Created by Emil Vaklinov on 03/11/2025.
//

import SwiftUI
import CoreData

@main
struct MuzzChatApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
