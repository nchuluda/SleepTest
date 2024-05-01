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
    @State var authenticated = false
    @StateObject var manager = HealthKitManager()
    
    var body: some View {
        VStack {
            Button("Access Health Data") {
                // OK To read or write HealthKit data here
            }
//            .disabled(!authenticated)
        }
        .padding()
        .task {
//            await manager.requestAuthorization()
            manager.authorizeHealthKit()
        }
//        .healthDataAccessRequest(store: manager.healthStore!,
//                                 shareTypes: [],
//                                 readTypes: [HKCategoryType(.sleepAnalysis)],
//                                 trigger: trigger) { result in
//            
//            switch result {
//            case .success(_):
//                authenticated = true
//            case .failure(let error):
//                // Handle the error
//                fatalError("*** An error occurred while requesting authorization")
//            }
//        }
    }
}

#Preview {
    ContentView()
}
