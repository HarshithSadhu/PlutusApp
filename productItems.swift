//
//  productItems.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/24/23.
//

import UIKit

struct products{
    let title: String
    let image: UIImage
}

let count = 0



let url = URL(string: "https://m.media-amazon.com/images/I/61V5O0UpgqS._AC_SX569_.jpg")
let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
let test = UIImage(data: data!)




let productsList: [products] = [products(title: "Head Phones", image: test!)]


extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
