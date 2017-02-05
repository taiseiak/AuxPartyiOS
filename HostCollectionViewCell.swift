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



class HostCreationCell: UICollectionViewCell , UITextFieldDelegate {
    
    
    //var searchDataSource: SearchDataSource?
    weak var JoinPartyViewControllerDelegate: JoinPartyViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        partyNameView.delegate = self
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Party ID Textfield
    let partyNameView: UITextField = {
        let tv = UITextField()
        tv.placeholder = "Party Name"
        tv.backgroundColor = UIColor.lightGray
        tv.clearButtonMode = .whileEditing
        tv.returnKeyType = UIReturnKeyType.join
        //tv.textAlignment = .center
        
        return tv
    }()
    
    //"Join" Label
    let joinPartyView: UILabel = {
        let tv = UILabel()
        tv.text = "Host"
        tv.textColor = .orange
        tv.textAlignment = .center
        
        return tv
    }()
    
    //Clears keyboard when user touches outside textbox or keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        partyNameView.resignFirstResponder()
    }
    
    //User presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //Clears keyboard
        partyNameView.resignFirstResponder()
        
        //Creats party
        if partyNameView.text != "" {
            createParty(partyName: partyNameView.text!, serviceName: "apple")
        }
        
        return true
    }
    
    //Setting up the Views
    func setupViews() {
        
        //Subviews
        addSubview(partyNameView)
        addSubview(joinPartyView)
        
        //Positioning
        joinPartyView.anchor(nil, left: leftAnchor, bottom: partyNameView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        partyNameView.anchor(topAnchor, left: leftAnchor, bottom: nil
            , right: rightAnchor, topConstant: 200, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0 , heightConstant: 50)
        
        
    }
    
    //Creates a party
    func createParty(partyName: String, serviceName: String) {
            
            let parameters: Parameters = [
                "user_name": partyName,
                "service_name": serviceName,
            ]
            let requestURL = "http://auxparty.com/api/host/create"
        
            Alamofire.request(requestURL, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON(completionHandler: {
                response in
                print(response)
                let readableJSON = response.result.value as! JSONStandard
                self.joinParty(partyID: readableJSON["identifier"] as! String)
            })
    }
    
    
    //Joins a party
    func joinParty(partyID: String) {
            
            Alamofire.request("http://auxparty.com/api/client/info/\(partyID.trimmingCharacters(in: .whitespaces))").responseJSON(completionHandler: {
                response in
                
                let readableJSON = response.result.value as! JSONStandard
                let exist = readableJSON["does_exist"] as! Bool
                
                if exist == true {
                    
                    let partyInformation = PartyRoom(partyID: readableJSON["identifier"] as! String!, partyName: readableJSON["user_name"] as! String!)
                    print("first step")
                    
                    self.JoinPartyViewControllerDelegate?.joinParty(partyInfo: partyInformation, user: "Host")
                } else {
                    
                    self.JoinPartyViewControllerDelegate?.showNotInAlert()
                    
                }
            })
            
    }

    
}
