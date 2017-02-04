//
//  PostRequest.swift
//  AuxPartyiOS
//
//  Created by Taisei Klasen on 1/2/17.
//  Copyright © 2017 DK. All rights reserved.
//


import UIKit
import LBTAComponents
import Alamofire



class PostRequestCell: UICollectionViewCell , UITextFieldDelegate {
    
    
    //var searchDataSource: SearchDataSource?
    weak var JoinPartyViewControllerDelegate: JoinPartyViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        partyIDView.delegate = self
        
        setupViews()
    }
    
    //Party ID Textfield
    let partyIDView: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Party ID"
        tv.backgroundColor = UIColor.lightGray
        tv.clearButtonMode = .whileEditing
        tv.returnKeyType = .join
        //tv.textAlignment = .center
        
        return tv
    }()
    
    //"Join" Label
    let joinPartyView: UILabel = {
        let tv = UILabel()
        tv.text = "Join"
        tv.textColor = .orange
        tv.textAlignment = .center
        
        return tv
    }()
    
    //Clears keyboard when user touches outside textbox or keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        partyIDView.resignFirstResponder()
    }
    
    //User presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Clears keyboard
        partyIDView.resignFirstResponder()
        
        //Joins party
        joinParty()
        
        return true
    }
    
    //Setting up the Views
    func setupViews() {
        
        //Subviews
        addSubview(partyIDView)
        addSubview(joinPartyView)
        
        //Positioning
        joinPartyView.anchor(nil, left: leftAnchor, bottom: partyIDView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        partyIDView.anchor(topAnchor, left: leftAnchor, bottom: nil
            , right: rightAnchor, topConstant: 200, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0 , heightConstant: 50)
        
        
    }
    
    
    //Joins a party
    func joinParty() {
        
        if partyIDView.text != "" {
            
            typealias JSONStandard = [String : AnyObject]
            
            Alamofire.request("http://auxparty.com/api/client/info/\(partyIDView.text!.trimmingCharacters(in: .whitespaces))").responseJSON(completionHandler: {
                response in
                
                let readableJSON = response.result.value as! JSONStandard
                let exist = readableJSON["does_exist"] as! Bool
                
                if exist == true {
                    
                    let partyInformation = PartyRoom(partyID: readableJSON["identifier"] as! String!, partyName: readableJSON["user_name"] as! String!)
                    print("first step")
                    
                    self.JoinPartyViewControllerDelegate?.joinParty(partyInfo: partyInformation)
                    
                } else {
                    
                    self.JoinPartyViewControllerDelegate?.showNotInAlert()
                    
                }
            })
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
