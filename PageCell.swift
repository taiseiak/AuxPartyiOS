//
//  File.swift
//  AuxPartyiOS
//
//  Created by Taisei Klasen on 12/14/16.
//  Copyright © 2016 DK. All rights reserved.
//

import UIKit
import LBTAComponents


class PageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let imageView: UIImageView = {
        let iv =  UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        iv.clipsToBounds = true
        return iv
        
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "sample text"
        tv.isEditable = false
        tv.autocorrectionType = .no
        return tv
    }()
    
    func setupViews() {
        
        addSubview(textView)
        addSubview(imageView)
        
        imageView.anchor(topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        textView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    
}
