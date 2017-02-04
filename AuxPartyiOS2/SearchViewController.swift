//
//  FirstViewController.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 1/12/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit
import Alamofire
import LBTAComponents

class SearchViewController: UIViewController, UISearchBarDelegate , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let searchBar = UISearchBar()
    
    var collectionView: UICollectionView!
    
    var songs = [Post]()
    
    //let letsSearchCell = []()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navbar
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(0.80)
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = "Request"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 35)
        titleLabel.textColor = .orange
        //navigationItem.titleView = titleLabel
        
        createSearchBar()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
        //callAlamoSong()
    }
    
    private func createSearchBar() {
        searchBar.placeholder = "Search for a Song"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        callAlamoSong(searchString: searchBar.text!)
    }
    
    func songReload() {
        collectionView.reloadData()
    }
    
    
    func callAlamoSong(searchString: String) {
        
        let escapedString = searchString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
        
        let searchURL = "https://itunes.apple.com/search?term=\(escapedString!)&limit=50&media=music&app=music"
        
        songs.removeAll()
        
        typealias JSONStandard = [String : AnyObject]
        
        Alamofire.request(searchURL).responseJSON(completionHandler: {
            response in
            
            let readableJSON = response.result.value as! JSONStandard
            
            print(readableJSON)
            
            if let tracks = readableJSON["results"] as? Array<AnyObject>{
                for i in 0..<tracks.count{
                    let item = tracks[i] as! JSONStandard
                    let name = item["trackName"] as! String
                    let trackID = item["trackId"] as! Int
                    let albumArtURlString = item["artworkUrl100"] as! String
                    let artistName = item["artistName"] as! String
                    let albumName = item["collectionName"] as! String
                    
                    let albumArtURL = URL(string: albumArtURlString)
                    let albumArtData = NSData(contentsOf: albumArtURL!)
                    let albumArt = UIImage(data: albumArtData as! Data)
                    let post = Post.init(mainImage: albumArt, name: name, trackID: trackID, artistName: artistName, albumName: albumName)
                    self.songs.append(post)
                }
            }
            self.songReload()
        })
    }
    
    func requestSongToHost(partyID: String, songID: Int, serviceName: String) {
        let parameters: Parameters = [
        "service_id": String(songID),
        "service_name": serviceName,
        "hype_val": "0.12345"
        ]
        let requestURL = "http://auxparty.com/api/client/request/\(partyID)"
        
        print(requestURL)
        print(parameters)
        
        Alamofire.request(requestURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseData(completionHandler: {
            response in
            print(response)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        searchCell.albumArtworkView.image = songs[indexPath.row].mainImage
        searchCell.songTitleLabel.text = songs[indexPath.row].name
        searchCell.artistTitleLabel.text = songs[indexPath.row].artistName
        searchCell.albumTitleLabel.text = String(songs[indexPath.row].albumName)
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath)
        requestSongToHost(partyID: "aaaaa", songID: songs[indexPath.row].trackID, serviceName: "apple_music")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 74)
    }

    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //layout.minimumLineSpacing = 0
        //layout.minimumInteritemSpacing = 0
        let cvrect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 49)
        collectionView = UICollectionView(frame: cvrect, collectionViewLayout: layout)
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "searchCell")
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
}








































/*extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        searchCell.albumArtworkView.image = songs[indexPath.row].mainImage
        searchCell.songTitleLabel.text = songs[indexPath.row].name
        searchCell.albumTitleLabel.text = String(songs[indexPath.row].trackID)
        return searchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("yay")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 74)
    }
}
*/
