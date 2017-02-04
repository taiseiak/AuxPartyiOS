//
//  SearchCollectionViewCell.swift
//  AuxPartyiOS2
//
//  Created by Taisei Klasen on 1/12/17.
//  Copyright © 2017 AuxParty. All rights reserved.
//

import UIKit
import LBTAComponents

class SearchCollectionViewCell: UICollectionViewCell {
    
    var albumArtView: UIImageView!

    //override in {
        //super.awakeFromNib()
        //albumArtView = UIImageView(frame: contentView.frame)
       // albumArtView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 100, /heightConstant: 100)
       // albumArtView.clipsToBounds = true
    //}
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        //Adding subviews
        addSubview(songTitleLabel)
        addSubview(albumArtworkView)
        addSubview(artistTitleLabel)
        addSubview(albumTitleLabel)
        addSubview(requestButton)
        
        //Trying to add shadow to album artwork
        self.albumArtworkView.layer.shadowOpacity = 0.3
        self.albumArtworkView.layer.shadowRadius = 1.0
        self.albumArtworkView.layer.shadowOffset = CGSize(width: 1, height: 2)
        self.albumArtworkView.layer.shouldRasterize = true
        
        //Positioning everything inside the cell
        albumArtworkView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 12, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        //requestButton.anchor(self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 31, leftConstant: 0, bottomConstant: 12, rightConstant: 20, widthConstant: 30, heightConstant: 30)
        songTitleLabel.anchor(albumArtworkView.topAnchor, left: albumArtworkView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        artistTitleLabel.anchor(songTitleLabel.bottomAnchor, left: albumArtworkView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 2, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        albumTitleLabel.anchor(artistTitleLabel.bottomAnchor, left: albumArtworkView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 2, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    //Album artwork
    let albumArtworkView: UIImageView = {
        let aAV = UIImageView()
        return aAV
    }()
    
    
    //Song label
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "song"
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 1.0
        label.layer.shadowPath = UIBezierPath(rect: label.bounds).cgPath
        label.layer.shouldRasterize = true
        return label
    }()
    
    
    //Artist label
    let artistTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "artist"
        label.textColor = .gray
        label.font = label.font.withSize(12)
        return label
    }()
    
    
    //Album label
    let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "album"
        label.textColor = .gray
        label.font = label.font.withSize(12)
        return label
    }()
    
    
    //Request button
    let requestButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
