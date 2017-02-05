//
//  SettingsViewController.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 1/14/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit
import LBTAComponents
import Alamofire

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    
    func setupViews() {
        view.addSubview(logOutButton)
        logOutButton.anchor(view.topAnchor, left: view.leftAnchor , bottom: nil, right: view.rightAnchor, topConstant: 60, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
    }
    
    let logOutButton: UIButton = {
       
        let but = UIButton()
        but.setTitle("Log Out", for: .normal)
        but.setTitleColor(.orange, for: .normal)
        but.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        but.backgroundColor = UIColor.lightGray
        return but
        
    }()
    
    func logOut() {
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        let tbc = tabBarController as! MainTabBarController
        let partyKey = tbc.partyKey
        let user = tbc.userState
        let partyID = tbc.partyID
        
        /*if user == "Host" {
        
            let parameters: Parameters = [
                "key": partyKey
                ]
            let requestURL = "http://auxparty.com/api/host/close/\(partyID)"
        
            Alamofire.request(requestURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData(completionHandler: {
                response in
                print(response)
            })
        }*/

        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HostOrJoin")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
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
