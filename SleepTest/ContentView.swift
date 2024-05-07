//
//  ContentView.swift
//  SleepTest
//
//  Created by Nathan on 4/30/24.
//

import SwiftUI
import HealthKit
import HealthKitUI
import UserNotifications
//import UserNotificationsUI

struct ContentView: View {
    @StateObject var manager = HealthKitManager()
//    @State var showWakeUpAlert = false
    
//    @AppStorage("receivedSleepData") var receivedSleepData: [String] = []
    
    var body: some View {
        VStack {
            Button("Authorize Health Data Access") {
                manager.requestAuthorization()
            }
            Button("Fetch Sleep Data") {
                manager.fetchSleepData()
            }
            Button("Start Observer Query") {
                manager.startObserverQuery()
            }
        }
        .padding()
        VStack {
            ForEach(manager.healthKitChanges, id: \.self) { change in
                Text(change)
            }
        }
        .padding(.top)
        
        .task {
            let center = UNUserNotificationCenter.current()

            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])
                print("Authorization requested")
            } catch {
                // Handle the error here.
                print("Notification authorization broken :(")
            }
        }
        .alert("HealthKit Store Changed! Did you fall asleep?", isPresented: $manager.showWakeUpAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    ContentView()
}
