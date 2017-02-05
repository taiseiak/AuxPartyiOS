//
//  MainTabBarController.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 2/3/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    func setNewPartyID(newpartyID: String) {
        print(newpartyID)
        self.partyID = newpartyID
        
    }
    
    var partyID = "has not changed"
    var userState = "has not been determined"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.partyID = appDelegate.currentPartyID
        self.userState = appDelegate.currentUserState
        print("maintabbar")
        
        /*if partyID == "has not changed" {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HostOrJoin")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
