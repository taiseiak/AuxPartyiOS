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
    var songNumber: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tbc = tabBarController as! MainTabBarController
        partyID = tbc.partyID
        userState = tbc.userState
        partyName = tbc.partyName
        partyKey = tbc.partyKey
        self.partyInfoLabel.text = "\(partyName) (\(partyID)) - \(userState)"
        if userState == "Host" {
            setSongToNextRequested()
        }
        
        currentlyPlaying()
        setupViews()
    }
    
    func setSongToNextRequested() {
        Alamofire.request("http://auxparty.com/api/host/data/\(partyID)?count=50").responseJSON(completionHandler: {
            response in
            
            let readableJSON = response.result.value as! JSONStandard
            if let songList = readableJSON["tracks"] as? Array<AnyObject>{
                if self.songNumber < songList.count {
                    let rightNowSongJSON = songList[self.songNumber] as! JSONStandard
                    let songInfoJSON = rightNowSongJSON["song"] as! JSONStandard
                    let playSongID = songInfoJSON["play_id"] as! String
                    self.setCurrentlyPlaying(withSong: playSongID)
                    self.songNumber += 1
                    self.currentlyPlaying()
                }
            }
        })
    }
    
    func setCurrentlyPlaying(withSong playSongID: String) {
            let parameters: Parameters = [
                "key": partyKey,
                "play_id": playSongID,
                "song_number": "1"
            ]
            let requestURL = "http://auxparty.com/api/neutral/nowplaying/\(partyID)"
            
            Alamofire.request(requestURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseString(completionHandler: {
                response in
                self.appleMusicPlayTrackId(ids: [playSongID])
            })
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
                self.songTitleLabel.text = "party is closed"
            } else if playID == "0" {
                self.songTitleLabel.text = "No song in que"
            } else {
                
                let albumArtworkSearchURL = "https://itunes.apple.com/lookup?id=\(playID)"
                
                Alamofire.request(albumArtworkSearchURL).responseJSON(completionHandler: {
                    response in
                    
                    let readableJSON2 = response.result.value as! JSONStandard
                    
                    if let track = readableJSON2["results"] as? Array<AnyObject>{
                        let item = track[0] as! JSONStandard
                        let name = item["trackName"] as! String
                        let albumArtURlString = item["artworkUrl100"] as! String
                        let artistName = item["artistName"] as! String
                        let albumName = item["collectionName"] as! String
                        let albumArtURL = URL(string: albumArtURlString)
                        let albumArtData = NSData(contentsOf: albumArtURL!)
                        let albumArt = UIImage(data: albumArtData as! Data)
                        
                        self.albumArtworkView.image = albumArt
                        self.songTitleLabel.text = name
                        self.songArtistLabel.text = artistName
                        self.songAlbumLabel.text = albumName
                    }
                    
                })
            }
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if userState == "Host" {
        //    setSongToNextRequested()
        //}
        currentlyPlaying()
    }
    
    func setupViews() {
        view.addSubview(partyInfoLabel)
        view.addSubview(albumArtworkView)
        view.addSubview(songTitleLabel)
        view.addSubview(songArtistLabel)
        view.addSubview(songAlbumLabel)
        view.addSubview(playNextSongButton)
        if userState == "Host" {
            playNextSongButton.anchor(nil, left: view.leftAnchor, bottom: albumArtworkView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        }
        
        
        partyInfoLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 27, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        albumArtworkView.frame = CGRect(x: Int((view.frame.width / 2)-((albumArtworkView.image?.size.width)!/2)), y: Int((view.frame.height / 2)-((albumArtworkView.image?.size.height)!/2)), width: Int((albumArtworkView.image?.size.width)!), height: Int((albumArtworkView.image?.size.height)!))
        songTitleLabel.anchor(albumArtworkView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        songArtistLabel.anchor(songTitleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        songAlbumLabel.anchor(songArtistLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 30)
        
        //if userState == "Host" {
        //    appleMusicPlayTrackId(ids: ["778788844"])
        //}
        
    }
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer()
    
    func appleMusicPlayTrackId(ids:[String]) {
        systemMusicPlayer.setQueueWithStoreIDs(ids)
        systemMusicPlayer.play()
    }
    
    
    let playNextSongButton: UIButton = {
    
    let but = UIButton()
    but.setTitle("NextSong", for: .normal)
    but.setTitleColor(.orange, for: .normal)
    but.addTarget(self, action: #selector(setSongToNextRequested), for: .touchUpInside)
    but.backgroundColor = UIColor.lightGray
    return but
    
    }()
    
    let partyInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "song not yet playing"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
        
    let songArtistLabel: UILabel = {
        let label = UILabel()
        label.text = "song not yet playing"
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let songAlbumLabel: UILabel = {
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

