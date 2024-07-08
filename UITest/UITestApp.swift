//
//  UITestApp.swift
//  UITest
//
//  Created by Kevin Chen on 7/7/24.
//

import SwiftUI

@main
struct UITestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
