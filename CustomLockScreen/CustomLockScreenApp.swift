//
//  CustomLockScreenApp.swift
//  CustomLockScreen
//
//  Created by Natalia on 11/15/24.
//

import SwiftUI

@main
struct CustomLockScreenApp: App {
    
    @State private var unlocked = false
    
    var body: some Scene {
        WindowGroup {
            if(unlocked) {
                ContentView()
            } else {
                LockScreen(unlocked: $unlocked)
            }
        }
    }
}
