//
//  MenuApp.swift
//  Menu
//
//  Created by Satoko Fujiyoshi on 2024/04/22.
//

import SwiftUI

@main
struct MenuApp: App {
    let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
