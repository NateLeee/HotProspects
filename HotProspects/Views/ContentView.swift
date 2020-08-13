//
//  ContentView.swift
//  HotProspects
//
//  Created by Nate Lee on 8/11/20.
//  Copyright © 2020 Nate Lee. All rights reserved.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Button("Request Permission") {
                UNUserNotificationCenter.current().requestAuthorization(
                options: [UNAuthorizationOptions.alert, .badge, .sound]) { (success, error) in
                    if (success) {
                        print("All set!")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            .padding()
            
            Button("Schedule Notification") {
                // second
                let content = UNMutableNotificationContent()
                content.title = "Test Notification Content title"
                content.subtitle = "Subtitle"
                content.sound = .defaultCritical
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            .padding()
        }
    }
    
    // Custom funcs
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
