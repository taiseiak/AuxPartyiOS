//
//  Structws.swift
//  AuxPartyiOS
//
//  Created by Taisei Klasen on 1/4/17.
//  Copyright © 2017 DK. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    let mainImage: UIImage!
    let name: String!
    let trackID: Int!
    let artistName: String!
    let albumName: String!
}

struct PartyRoom {
    let partyID: String!
    let partyName: String!
}

typealias JSONStandard = [String : AnyObject]
