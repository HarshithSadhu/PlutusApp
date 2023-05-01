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
    
    @IBOutlet weak var pricelim: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    
    
    public func configure(with image: UIImage, productName: String, productPrice:Float, productLim:Float){
        productImg.image = image
        productDetails.text = productName
        
        let doubleStr = String(format: "%.2f", productPrice)
        priceLbl.text = "$" + String(doubleStr)
        //pricelim.text = "Lim: " + String(productLim)
        //productImg.layer.cornerRadius = 5.0
        //productImg.layer.masksToBounds = true
        
    }
    
}
