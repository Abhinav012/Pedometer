//
//  ViewController.swift
//  Core Motion
//
//  Created by Abhinav Verma on 17/10/17.
//  Copyright © 2017 Abhinav Verma. All rights reserved.
//

import UIKit
import CoreMotion
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var distannce: UILabel!
    @IBOutlet weak var caloriesBurned: UILabel!
    @IBOutlet weak var shareButton: UIButton!
 
    var isAuthorized: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       isAuthorized = HealthKitManager.main.authorizeHealthKit()
    
       
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
       
        self.schedule()
    }
    
    func schedule()
    {
    
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.getHealthData), userInfo: nil, repeats: true)
        
        timer.fire()
        
        
    }
    
    
    
    
    func getHealthData()
    {
    
        
        if isAuthorized
        {
            HealthKitManager.main.getSteps()
                {
                    (stepsCount) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                      
                        self.steps.text! = String(stepsCount)
                    })
                    
                 }
            
            
            HealthKitManager.main.getWalkingRunningDistance()
                {
                    (distance) -> Void in
                    
                    DispatchQueue.main.async(execute: {
                        //Set UILabel Value
                        self.distannce.text! = String(distance)
                    })
                }
        }

    
    }
    
    
    @IBAction func sharedButtonPressed(_ sender: UIButton) {
        
       let activityViewController = UIActivityViewController(activityItems: ["Travelled \(self.distannce.text!) m of distance ","Completed \(self.steps.text!) steps"], applicationActivities: nil)

       activityViewController.popoverPresentationController?.sourceView = self.view
        
       self.present(activityViewController, animated: true, completion: nil)
    }

}

