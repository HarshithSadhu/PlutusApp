//
//  homePage.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit

class homePage: UIViewController, UICollectionViewDataSource {
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    
    // state here
    var aStruct: GetProductsResponse? = nil
    
    var productImgLinks = ["https://m.media-amazon.com/images/I/61V5O0UpgqS._AC_SX679_.jpg", "https://m.media-amazon.com/images/I/81t6ws1HsWL._AC_SY240_.jpg", "https://m.media-amazon.com/images/I/71EfSxJs-aL._AC_SX679_.jpg"]
    var productData = ["Amazon Echo", "Bounty Paper", "Violin Strings", "asdf"]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aStruct!.products.count
        
    }
    
    struct GetProductsResponse: Decodable {
        let products: [Product]
    }
    
    struct Product: Decodable {
        let asin: String
        let name: String
        let price: Float
        let priceLimit: Float
        let imageUrl: String
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        
        if let productCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? productCell{
            
            productCell2.productImg.layer.cornerRadius = 20.0
            productCell2.productImg.layer.masksToBounds = true
            
            let url = URL(string: self.aStruct!.products[indexPath.row].imageUrl as! String)
            
            let data = (try? Data(contentsOf: url!))!
            
            productCell2.configure(with: UIImage(data: data)!, productName: self.aStruct!.products[indexPath.row].name, productPrice: self.aStruct!.products[indexPath.row].price, productLim: self.aStruct!.products[indexPath.row].priceLimit)
                
            
            cell = productCell2
        }
        
        //
       
        
        return cell
            
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        print(productImgLinks)
        collectionViewOutlet.layer.cornerRadius = 5.0
        collectionViewOutlet.layer.masksToBounds = true
        collectionView.dataSource = self
        
        
        getCall()
        
        while(self.aStruct?.products[0].price == nil){
            
        }
        
        print(self.aStruct!.products.count)
        
        //print(aStruct!.products.count)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func getCall() {
        
        let deviceToken = (UIDevice.current.identifierForVendor?.uuidString)!
        // Create URL
        let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/get-products?page=0&limit=25&deviceToken=" + deviceToken)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                let jsonData = Data(dataString.utf8)
                let response: GetProductsResponse = try! JSONDecoder().decode(GetProductsResponse.self, from: jsonData)
                //let price = (data.get("products"))
                self.aStruct = response
                
                
                //print(self.aStruct?.products[0].price)
                //print(self.aStruct?.products[0].price)
                
            }
            
        }
        task.resume()
        
    }
    @IBAction func btnpress(_ sender: Any) {
        print(self.aStruct?.products[0].price)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     
     
     
     @IBAction func btnPress(_ sender: Any) {
     }
     */
    
    

}
