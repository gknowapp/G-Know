//
//  GKnowApp.swift
//  GKnow
//
//  Created by Catherine Chu on 8/29/24.
//

import SwiftUI

@main
struct GKnowApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
