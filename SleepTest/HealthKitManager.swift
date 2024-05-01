//
//  HealthKitManager.swift
//  SleepTest
//
//  Created by Nathan on 4/30/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
//    var healthStore: HKHealthStore?
    let healthStore = HKHealthStore()
    
    init() { }
        
//    func requestAuthorization() async {
//        do {
//            if HKHealthStore.isHealthDataAvailable() {
////            if healthStore.isHealthDataAvailable() {
////                self.healthStore = HKHealthStore()
//                healthStore.requestAuthorization(toShare: [], read: [HKCategoryType(.sleepAnalysis)]) { (success, error) in
//                    
//                }
//            }
//        } catch {
//            print("Error authorizing healthStore")
//        }
//    }
    
    
    func authorizeHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: [], read: [HKCategoryType(.sleepAnalysis)]) { (success, error) in
                if success {
                    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                    let query = HKSampleQuery(sampleType: HKCategoryType(.sleepAnalysis), predicate: nil, limit: 30, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
                        guard let samples = samples as? [HKCategorySample], error == nil else {
                            print("Failed to fetch sleep data: \(error!.localizedDescription)")
                            return
                        }
                        for sample in samples {
                            let startDate = sample.startDate
                            let endDate = sample.endDate
                            print("Sleep start: \(startDate), end: \(endDate)")
                        }
                    }
                    self.healthStore.execute(query)
                } else {
                    print("Authorization to access sleep data was denied.")
                }
            }
        }
    }
}
