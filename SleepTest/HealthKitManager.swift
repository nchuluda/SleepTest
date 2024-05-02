//
//  HealthKitManager.swift
//  SleepTest
//
//  Created by Nathan on 4/30/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    var healthKitAuthorized = false
    
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
//        print("Called fetchSleepData()")
        if healthKitAuthorized {
            let sortDesriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: nil, limit: 30, sortDescriptors: [sortDesriptor]) {
                (query, samples, error) in
                guard let samples = samples as? [HKCategorySample], error == nil else {
                    print("Failed to fetch sleepd ata: \(error!.localizedDescription)")
                    return
                }
                for sample in samples {
                    print("\(self.sleepCategory(sample.value)):")
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
    
    func sleepCategory(_ value: Int) -> String {
        switch value {
        case 0:
            return "In Bed"
        case 3:
            return "Core"
        case 4:
            return "Deep"
        case 5:
            return "REM"
        default:
            return "Unknown"
        }
    }
}
