//
//  homePage.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit

class homePage: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    var productImgLinks = ["https://m.media-amazon.com/images/I/61V5O0UpgqS._AC_SX679_.jpg", "https://m.media-amazon.com/images/I/81t6ws1HsWL._AC_SY240_.jpg", "https://m.media-amazon.com/images/I/71EfSxJs-aL._AC_SX679_.jpg"]
    var productData = ["Amazon Echo", "Bounty Paper", "Violin Strings", "asdf"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImgLinks.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        
        if let productCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? productCell{
            
            productCell2.productImg.layer.cornerRadius = 20.0
            productCell2.productImg.layer.masksToBounds = true
            
            let url = URL(string: productImgLinks[indexPath.row] as! String)
            
            let data = (try? Data(contentsOf: url!))!
            
            productCell2.configure(with: UIImage(data: data)!, productName: productData[indexPath.row])
            
            cell = productCell2
        }
        
        
        return cell
            
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("shit")
        print(productImgLinks)
        collectionViewOutlet.layer.cornerRadius = 5.0
        collectionViewOutlet.layer.masksToBounds = true
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     
     
     
    */
    
    

}
