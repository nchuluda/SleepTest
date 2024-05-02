//
//  ContentView.swift
//  SleepTest
//
//  Created by Nathan on 4/30/24.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct ContentView: View {
    @StateObject var manager = HealthKitManager()
    
    var body: some View {
        VStack {
            Button("Authorize Health Data Access") {
                manager.requestAuthorization()
            }
            Button("Fetch Sleep Data") {
                manager.fetchSleepData()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
