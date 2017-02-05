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
import StoreKit
import MediaPlayer

class NowPlayingViewController: UIViewController {
    
    var partyID = ""
    var userState = ""
    var partyName = ""
    var partyKey = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tbc = tabBarController as! MainTabBarController
        partyID = tbc.partyID
        userState = tbc.userState
        partyName = tbc.partyName
        partyKey = tbc.partyKey
        self.partyInfoLabel.text = "\(partyName) (\(partyID)) - \(userState)"
        currentlyPlaying()
        setupViews()
    }
    
    
    func currentlyPlaying() {
        
        Alamofire.request("http://auxparty.com/api/neutral/nowplaying/\(partyID)?count=5").responseJSON(completionHandler: {
            response in
            
            let readableJSON = response.result.value as! JSONStandard
            let isClosed = readableJSON["is_closed"] as! Bool
            let playID = readableJSON["play_id"] as! String
            
            print(isClosed)
            print(playID)
            
            if isClosed {
                self.songInfoLabel.text = "party is closed"
            } else if playID == "0" {
                self.songInfoLabel.text = "No song in que"
            } else {
                self.songInfoLabel.text = playID
            }
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if userState == "Host" {
            let parameters: Parameters = [
                "key": partyKey,
                "play_id": "778788844",
                "song_number": "10"
                ]
            let requestURL = "http://auxparty.com/api/newtral/nowplaying/\(partyID)"
            
            Alamofire.request(requestURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: {
                response in
                print(response)
            })

        }
        currentlyPlaying()
    }
    
    func setupViews() {
        view.addSubview(partyInfoLabel)
        view.addSubview(albumArtworkView)
        view.addSubview(songInfoLabel)
        
        partyInfoLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 27, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        albumArtworkView.frame = CGRect(x: Int((view.frame.width / 2)-((albumArtworkView.image?.size.width)!/2)), y: Int((view.frame.height / 2)-((albumArtworkView.image?.size.height)!/2)), width: Int((albumArtworkView.image?.size.width)!), height: Int((albumArtworkView.image?.size.height)!))
        songInfoLabel.anchor(albumArtworkView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        if userState == "Host" {
            appleMusicPlayTrackId(ids: ["201234458"])
        }
        
    }
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    func appleMusicPlayTrackId(ids:[String]) {
        systemMusicPlayer.setQueueWithStoreIDs(ids)
        systemMusicPlayer.play()
    }
    
    //Artist label
    let partyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let songInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "song not yet playing"
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

