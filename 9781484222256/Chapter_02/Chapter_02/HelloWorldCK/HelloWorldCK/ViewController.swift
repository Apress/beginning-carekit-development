//
//  ViewController.swift
//  HelloWorldCK
//
//  Created by Chris Baxter on 25/05/2016.
//  Copyright © 2016 Catalyst Mobile Ltd. All rights reserved.
//

import UIKit
import CareKit

class ViewController: UIViewController {
    
    let store: OCKCarePlanStore
    
    required init?(coder aDecoder: NSCoder) {
        let fileManager = NSFileManager.defaultManager()
        
        guard let documentDirectory =   fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last else {
            fatalError("*** Error: Unable to get the document directory! ***")
        }
        
        let storeURL = documentDirectory.URLByAppendingPathComponent("HelloCareKitStore")
        
        if !fileManager.fileExistsAtPath(storeURL.path!) {
            try! fileManager.createDirectoryAtURL(storeURL,     withIntermediateDirectories: true, attributes: nil)
        }
        
        store = OCKCarePlanStore(persistenceDirectoryURL: storeURL)
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a single hello world activity to the store
        createActivity()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createActivity() {
        
        let MyMedicationIdentifier = "HelloActivity"
        
        store.activityForIdentifier(MyMedicationIdentifier) { (success, foundActivity, error) in
            
            guard success else {
                // perform real error handling here.
                fatalError("*** An error occurred \(error?.localizedDescription) ***")
            }
            
            if let activity = foundActivity {
                
                //activity already exists
                print("Activity found - \(activity.identifier)")
            }
            else {
                
                //create the activity
                // take medication twice a day, every day starting March 15, 2016
                let startDay = NSDateComponents(year: 2016, month: 3, day: 15)
                let thriceADay = OCKCareSchedule.dailyScheduleWithStartDate(startDay, occurrencesPerDay: 3)
                
                //instantiate the activity
                let medication = OCKCarePlanActivity(
                    identifier: MyMedicationIdentifier,
                    groupIdentifier: nil,
                    type: .Intervention,
                    title: "Hellow World",
                    text: "Say it out loud",
                    tintColor: nil,
                    instructions: "Say Hello to the world 3 times a day. This should make you feel better. It is not recommended to shout too loudly or you may damage your vocal chords.. For any severe side effects, please contact your medical guru.",
                    imageURL: nil,
                    schedule: thriceADay,
                    resultResettable: true,
                    userInfo: nil)
                
                self.store.addActivity(medication, completion: { (success, error) in
                    
                    guard success else {
                        // perform real error handling here.
                        fatalError("*** An error occurred \(error?.localizedDescription) ***")
                    }
                    
                })
            }
            
        }
    }

    @IBAction func showCareCard(sender: AnyObject) {
        
        let careCardViewController = OCKCareCardViewController(carePlanStore: store)
        
        // presenting the view controller modally
        self.navigationController?.pushViewController(careCardViewController, animated: true)
    }

}

