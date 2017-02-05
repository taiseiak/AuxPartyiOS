//
//  SecondViewController.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 1/12/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit
import Alamofire
import LBTAComponents

class NowPlayingViewController: UIViewController {
    
    var partyID = ""
    var userState = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        currentlyPlaying()
        setupViews()
    }
    
    func currentlyPlaying() {
        
        let tbc = tabBarController as! MainTabBarController
        partyID = tbc.partyID
        userState = tbc.userState
        print(tbc.partyID)
        print(partyID)
        
        Alamofire.request("http://auxparty.com/api/host/data/\(partyID)?count=5").responseJSON(completionHandler: {
            response in
            
            print(response)
            
            let readableJSON = response.result.value as! JSONStandard
            let userName = readableJSON["user_name"] as! String
            let identifier = readableJSON["identifier"] as! String
            
            self.partyInfoLabel.text = "\(userName) - ID: \(identifier) \(self.userState)"
            
            
            print(readableJSON)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentlyPlaying()
    }
    
    func setupViews() {
        view.addSubview(partyInfoLabel)
        view.addSubview(albumArtworkView)
        
        partyInfoLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 27, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        albumArtworkView.frame = CGRect(x: Int((view.frame.width / 2)-((albumArtworkView.image?.size.width)!/2)), y: Int((view.frame.height / 2)-((albumArtworkView.image?.size.height)!/2)), width: Int((albumArtworkView.image?.size.width)!), height: Int((albumArtworkView.image?.size.height)!))
    }
    
    //Artist label
    let partyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let albumArtworkView: UIImageView = {
        let aAV = UIImageView()
        aAV.image = #imageLiteral(resourceName: "AuxPartyLogo-310")
        return aAV
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

