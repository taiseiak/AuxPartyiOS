//
//  LogInViewController.swift
//  AuxPartyiOS
//
//  Created by Taisei Klasen on 12/14/16.
//  Copyright © 2016 DK. All rights reserved.
//

import UIKit

protocol JoinPartyViewControllerDelegate: class {
    func joinParty(partyInfo: PartyRoom, user: String)
    func showNotInAlert()
}

class JoinPartyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JoinPartyViewControllerDelegate {
    
    //Set up collection view
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
        
    }()
    
    //Join the Party
    func joinParty(partyInfo: PartyRoom, user: String) {
        print("joining \(partyInfo.partyID as String)")
        
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        
        appDelegate.currentPartyID = partyInfo.partyID
        appDelegate.currentUserState = user
        
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // Close keyboard when user scrolls
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    //Show the alert
    func showNotInAlert() {
        let alertController = UIAlertController(title: nil, message: "Party does not exist", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //Cell ID's
    let cellId = "cellID"
    let hostCellId = "hostCellID"
    
    //Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        collectionView.register(PostRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HostCreationCell.self, forCellWithReuseIdentifier: hostCellId)
    }
    
    //Items in collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    //Choosing the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellId, for: indexPath) as! PostRequestCell
            
            cell.JoinPartyViewControllerDelegate = self
            
            return cell
        }
        let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier:hostCellId, for: indexPath) as! HostCreationCell
        
        hostCell.JoinPartyViewControllerDelegate = self
            
        return hostCell
    }
    
    //Size of collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
