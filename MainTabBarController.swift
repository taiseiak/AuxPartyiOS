//
//  MainTabBarController.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 2/3/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer
import Alamofire



class MainTabBarController: UITabBarController {
    
    var partyID = "has not changed"
    var userState = "has not been determined"
    var partyName = "has not been named"
    var storeFrontID = "has not yet been determined"
    var partyKey = "has not been determined(key)"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("maintabbar")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.partyID = appDelegate.currentPartyID
        self.userState = appDelegate.currentUserState
        self.partyKey = appDelegate.currentPartyKey
        Alamofire.request("http://auxparty.com/api/client/info/\(self.partyID)").responseJSON(completionHandler: {
            response in
            
            let readableJSON = response.result.value as! JSONStandard
            self.partyName = readableJSON["user_name"] as! String
        })
        
        if self.userState == "host" {
            appleMusicCheckIfDeviceCanPlay()
            appleMusicRequestPermission()
        }
    }
    
    func appleMusicCheckIfDeviceCanPlay() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities(completionHandler: { (capability:SKCloudServiceCapability, error:Error?) in
            
            switch capability {
                
            case SKCloudServiceCapability.musicCatalogPlayback:
                
                print("The user has an Apple Music subscription and can playback music!")
                
            case SKCloudServiceCapability.addToCloudMusicLibrary:
                
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
                
            default:
                print("The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
                break
            }
        })
        
    }
    
    func appleMusicRequestPermission() {
        switch SKCloudServiceController.authorizationStatus() {
            
        case .authorized:
            
            print("The user's already authorized - we don't need to do anything more here, so we'll exit early.")
            return
            
        case .denied:
            
            print("The user has selected 'Don't Allow' in the past - so we're going to show them a different dialog to push them through to their Settings page and change their mind, and exit the function early.")
            
            let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
            
        case .notDetermined:
            
            print("The user hasn't decided yet - so we'll break out of the switch and ask them.")
            break
            
        case .restricted:
            
            print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            return
            
        }
        
        SKCloudServiceController.requestAuthorization({ (status) in
            switch status {
                
            case .authorized:
                
                print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
                
            case .denied:
                
                print("The user tapped 'Don't allow'. Read on about that below...")
                
            case .notDetermined:
                
                print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
                
            case .restricted:
                
                print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
                
            }
        })
    }
    
    func appleMusicFetchStorefrontRegion() {
        
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier { (storefrontID, err) in
            guard err == nil else {
                
                print("An error occured. Handle it here.")
                return
                
            }
            
            guard let storefrontId = storefrontID, storefrontId.characters.count >= 6 else {
                
                print("Handle the error - the callback didn't contain a valid storefrontID.")
                return
                
            }
            
            let indexRange = storefrontId.index(storefrontId.startIndex, offsetBy: 5)
            let trimmedId = storefrontId.substring(to: indexRange)
            
            
            print("Success! The user's storefront ID is: \(trimmedId)")
            self.storeFrontID = trimmedId
        }
    }
    
    
        /*if partyID == "has not changed" {
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
     
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HostOrJoin")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }*/

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
