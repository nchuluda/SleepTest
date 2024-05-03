//
//  HealthKitManager.swift
//  SleepTest
//
//  Created by Nathan on 4/30/24.
//

import Foundation
import HealthKit
import UserNotifications

@MainActor
class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    var healthKitAuthorized = false
    @Published var showWakeUpAlert = false
    
    init() { }
    
    func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: [], read: [HKCategoryType(.sleepAnalysis)]) { (success, error) in
                if success {
                    self.healthKitAuthorized = true
                } else {
                    print("Authorization to access sleep data was denied.")
                }
            }
        } 
    }
    
    func fetchSleepData() {
        if healthKitAuthorized {
            let sortDesriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: nil, limit: 30, sortDescriptors: [sortDesriptor]) {
                (query, samples, error) in
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Failed to fetch sleep data: \(error!.localizedDescription)")
                    return
                }
                for sample in samples {
                    if let sleepCategory = HKCategoryValueSleepAnalysis(rawValue: sample.value) {
                        print("\(self.description(sleepCategory)):")
                    }
                    let startDate = sample.startDate
                    let endDate = sample.endDate
                    print("Start: \(startDate), End: \(endDate)")
                }
            }
            self.healthStore.execute(query)
        } else {
            requestAuthorization()
        }
    }
    
    func startObserverQuery() {
        if healthKitAuthorized {
            let query = HKObserverQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: nil) { (query, completionHandler, errorOrNil) in
                if let error = errorOrNil {
                    // Properly handle the error.
                    print(error)
                    return
                }
                // Take whatever steps are necessary to update your app.
                // This often involves executing other queries to access the new data.
                
//                print("HealthKitStore changed at \(Date())")

                // NOTIFICATION
                let content = UNMutableNotificationContent()
                content.title = "You fell asleep!"
                content.body = "Wake up and journal."
                content.sound = .default
                
                let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
                // ALERT
                self.showWakeUpAlert = true
                
                // If you have subscribed for background updates you must call the completion handler here.
                completionHandler()
            }
            self.healthStore.execute(query)
        } else {
            requestAuthorization()
        }
    }
    
    func description(_ sleepCategory: HKCategoryValueSleepAnalysis) -> String {
        switch sleepCategory {
        case .inBed:
            return "In bed"
        case .asleepUnspecified:
            return "Unspecified"
        case .asleep:
            return "Asleep"
        case .awake:
            return "Awake"
        case .asleepCore:
            return "Core"
        case .asleepDeep:
            return "Deep"
        case .asleepREM:
            return "REM"
        default:
            return "Unknown"
        }
    }
}
