//
//  BudgieProfileGalleryCell.swift
//  Budgie
//
//  Created by Francisco de la Pena on 5/30/15.
//  Copyright (c) 2015 Twister Labs, LLC. All rights reserved.
//

import UIKit

class BudgieProfileGalleryCell: UICollectionViewCell {
    
    @IBOutlet var mediaImageView: UIImageView!
    
    var imageUrl: String! {
        didSet {
            mediaImageView.setImageWithURL(NSURL(string: imageUrl))
        }
    }
}
