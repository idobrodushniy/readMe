//
//  ReadMeApp.swift
//  ReadMe
//
//  Created by Ilia on 28.11.2022.
//

import SwiftUI

@main
struct ReadMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Library())
        }
    }
}
