//
//  HealthKitManager.swift
//  Core Motion
//
//  Created by Abhinav Verma on 19/10/17.
//  Copyright © 2017 Abhinav Verma. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {
    
    static let main = HealthKitManager()
    let healthStore = HKHealthStore()
    let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let now = Date()
    var distanceCount = 0.0
    var resultCount = 0.0
    
    func authorizeHealthKit() -> Bool
    {
         var isEnabled = true
        var hkquantities : Set<HKObjectType> = Set<HKObjectType>()

        hkquantities.insert(HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
        hkquantities.insert(quantityType!)
        
        
        if HKHealthStore.isHealthDataAvailable()
        {
        
        healthStore.requestAuthorization(toShare: nil, read: hkquantities, completion: { (success, error) in
               
        isEnabled=success
        })
        
        }
        else
        {
            isEnabled = false
            
    
    
    }
        
    
        
        return isEnabled
    }
    
    
    public func getSteps(completion : @escaping (_ steps : Int)-> ()) {
        
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate   )
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
          
            
            guard let result = result else {
                print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
                
                return
            }
            
            if let sum = result.sumQuantity() {
                self.resultCount = sum.doubleValue(for: HKUnit.count())
                print(self.resultCount)
                
                completion(Int(self.resultCount))
            }
            

        }
        
        healthStore.execute(query)    }
    
    
    
   public func getWalkingRunningDistance(completion : @escaping (_ walkingRunningDistance : Int)-> ())
    {
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: HKQueryOptions.strictStartDate)
        let distanceQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        let query = HKStatisticsQuery(quantityType: distanceQuantityType!, quantitySamplePredicate: predicate, options: HKStatisticsOptions.cumulativeSum) { (_, result, error) in
           
            
        guard let result = result else
            {
              
                   print("Failed to fetch steps = \(error?.localizedDescription ?? "N/A")")
             
              return
            }
            
            if let distanceSum = result.sumQuantity(){
                self.distanceCount = distanceSum.doubleValue(for: HKUnit.meter())
                print(self.distanceCount)
                
                completion(Int(self.distanceCount))
            }
            
            
        }
        
        healthStore.execute(query)
    
    }
    
}
