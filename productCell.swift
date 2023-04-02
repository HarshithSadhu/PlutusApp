//
//  productCell.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit

class productCell: UICollectionViewCell {
    
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    
    
    
    
    public func configure(with image: UIImage, productName: String){
        productImg.image = image
        productDetails.text = productName
        
        productImg.layer.cornerRadius = 5.0
        productImg.layer.masksToBounds = true
        
    }
    
}
