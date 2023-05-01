//
//  homePage.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit
import NVActivityIndicatorView
import BackgroundRemoval

class homePage: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    @IBOutlet weak var box: UIImageView!
    
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var priceNameLbl: UILabel!
    // state here
    let defaults = UserDefaults.standard
    
    var selectedIndex = 0
    var aStruct: GetProductsResponse? = nil
    var token = ""
    var productImgLinks = ["https://m.media-amazon.com/images/I/61V5O0UpgqS._AC_SX679_.jpg", "https://m.media-amazon.com/images/I/81t6ws1HsWL._AC_SY240_.jpg", "https://m.media-amazon.com/images/I/71EfSxJs-aL._AC_SX679_.jpg"]
    var productData = ["Amazon Echo", "Bounty Paper", "Violin Strings", "asdf"]
    
    
    @IBOutlet weak var invalidNumber: UILabel!
    
    @IBAction func deleteButton2(_ sender: Any) {
        activityIndicator.startAnimating()
        removeCell()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.getCall()
            
        }
    }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.aStruct?.products == nil{
            
            return 0
            
        }
            
        return self.aStruct!.products.count
        
    }
    
    struct GetProductsResponse: Decodable {
        let products: [Product]
    }
    
    struct Product: Decodable {
        let asin: String
        var name : String
        let price: Float
        let priceLimit: Float
        let imageUrl: String
        let isBelowLimit: Bool
    }
    
    
    
    @IBOutlet weak var limField: UITextField!
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        var cell = UICollectionViewCell()
        
        if let productCell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? productCell{
            
            //productCell2.productImg.layer.cornerRadius = 20.0
            //productCell2.productImg.layer.masksToBounds = true
            
            
            
            let url = URL(string: self.aStruct!.products[indexPath.row].imageUrl as! String)
            
            let data = (try? Data(contentsOf: url!))!
            
            if(self.aStruct!.products[indexPath.row].isBelowLimit){
                
                let imageName = "green.png"
                let image = UIImage(named: imageName)
                
                productCell2.configure(with: image!, productName: self.aStruct!.products[indexPath.row].name, productPrice: self.aStruct!.products[indexPath.row].price, productLim: self.aStruct!.products[indexPath.row].priceLimit)
            }
            else{
                
                let imageName = "white.png"
                let image = UIImage(named: imageName)
                
                productCell2.configure(with: image!, productName: self.aStruct!.products[indexPath.row].name, productPrice: self.aStruct!.products[indexPath.row].price, productLim: self.aStruct!.products[indexPath.row].priceLimit)
            }
            
            
            
            
            productCell2.layer.cornerRadius=10
            //if selectedIndex == indexPath.row { productCell2.backgroundColor = UIColor.black }
            let backgroundView = UIView()
            let color2 = UIColor(rgb: 0x595959)
            backgroundView.backgroundColor = color2
                productCell2.selectedBackgroundView = backgroundView
            
            
            
            let imageName = "Empty.png"
            let image = UIImage(named: imageName)
            
            
            
            cell = productCell2
        }
        
        //
       
        
        return cell
            
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 1000, height: 1000)
    }
    
    
    
    @IBAction func updateButton(_ sender: Any) {
        activityIndicator.startAnimating()
        updateCell()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getCall()
        }
        
        
    }
    
    
    func updateCell(){
        
        
        guard let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/update-price-limit") else{
            return
        }
                
        func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let body: [String: String] = ["link": stringLink]
        
        //let deviceToken = UIDevice.current.identifierForVendor?.uuidString
        
        

        
        let body: [String: Any] = ["asin": asinLbl.text, "priceLimit": Float(limField.text!), "deviceToken": token]
        
        let body2: [String: Any] = ["page": 1, "limit": 3, "deviceToken": token, "sortBy": "name", "sortOrder": "asc"]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let group = DispatchGroup()
            group.enter()
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            
                let response = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                
                
                
                group.leave()
            
            
            
            
            
        }
        
        
        task.resume()
        
        
        group.notify(queue: .main) {
            //self.hideElements()
            
            self.activityIndicator.stopAnimating()
            
            
            
            
            if let floatThing = Float(self.limField.text!){
                
                let doubleStr = String(format: "%.2f", floatThing)
                
            
                print(doubleStr)
                
                self.limLblReal.text = "$" + doubleStr
            }
            else{
                self.invalidNumber.isHidden = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.invalidNumber.isHidden = true
                }
                
                
            }
            
            
            
            
            
           
            
            
            
            self.collectionViewOutlet.reloadData()
            
            
            
            
            
           
            }
        
        
        
        
        
        
        
        
    }
    
    
    func removeCell(){
        
        
        guard let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/remove-product") else{
            return
        }
                
        
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let body: [String: String] = ["link": stringLink]
        
        //let deviceToken = UIDevice.current.identifierForVendor?.uuidString
        
        

        
        let body: [String: Any] = ["asin": asinLbl.text,  "deviceToken": token]
        
        let body2: [String: Any] = ["page": 1, "limit": 3, "deviceToken": token, "sortBy": "name", "sortOrder": "asc"]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let group = DispatchGroup()
            group.enter()
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            
                let response = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                
                
                
                group.leave()
            
            
            
            
            
        }
        
        
        task.resume()
        
        
        group.notify(queue: .main) {
            
            self.activityIndicator.stopAnimating()
            self.collectionViewOutlet.reloadData()
            //uncomment
            self.resetDash()
            }
        
        
        
        
        
        
        
        
    }
    
    @IBAction func addItem(_ sender: Any) {
        performSegue(withIdentifier: "addItemSegue", sender: self)
        
    }
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var limLbl: UILabel!
    
    @IBOutlet weak var limLblReal: UILabel!
    @IBOutlet weak var curPrice: UILabel!
    @IBOutlet weak var blur: UIVisualEffectView!
    
    @IBOutlet weak var limLblReal2: UILabel!
    @IBOutlet weak var prodName2: UILabel!
    @IBOutlet weak var prodName: UILabel!
    @IBOutlet weak var asinLbl: UILabel!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
        
        //img2.image = UIImage(data: data)
        
        let doubleStr = String(format: "%.2f", self.aStruct!.products[indexPath.row].price)
        curPrice.text = "$" + doubleStr
        //prodName.text = String(self.aStruct!.products[indexPath.row].name)
        
        prodName2.text = String(self.aStruct!.products[indexPath.row].name)
        
        
        limLblReal.text = "$" +  String(self.aStruct!.products[indexPath.row].priceLimit) + "0"
        
        limField.placeholder = "$" +  String(self.aStruct!.products[indexPath.row].priceLimit) + "0"
        
        limField.text = ""
        
        asinLbl.text = String(self.aStruct!.products[indexPath.row].asin)
        
        let url = URL(string: self.aStruct!.products[indexPath.row].imageUrl as! String)
        
        let data = (try? Data(contentsOf: url!))!
        
        
        
        img1.image = BackgroundRemoval.init().removeBackground(image: UIImage(data: data)!)
        
        
        
        
        /*dismissBtn.isHidden = false
        blur.isHidden = false
        showElements()
        
        
        
        
        //priceLbl.text = aStruct?.products[0].price as String
        priceLbl.text = "Price: " +  String(self.aStruct!.products[indexPath.row].price)
        
        priceNameLbl.text = "Name: " +  String(self.aStruct!.products[indexPath.row].name)
        
        limitLbl.text = "Limit: " +  String(self.aStruct!.products[indexPath.row].priceLimit)
        
        textField.text = String(self.aStruct!.products[indexPath.row].priceLimit)
        
        
        //String(self.aStruct?.products[indexPath.row].price)
        
         */
        //let indexesToRedraw = [indexPath]
        //selectedIndex = indexPath.row
        //collectionView.reloadItems(at: [indexPath])
        
        print("Row is " + String(indexPath.row))
         
         
        
    }
    
    
    func resetDash(){
        
        if(self.aStruct == nil){
            addItemBtn.isHidden = false
            let imageName = "Empty.png"
            let image = UIImage(named: imageName)
            
            
            
            img1.image = image
            //img2.image = image
            curPrice.text = "$00.00"
            prodName.text = "Add an Item"
            
            prodName2.text = "Add an Item"
            
            
            limLblReal.text = "$00.00"
            
            limField.placeholder = "$00.00"
            
            limField.text = ""
            
            asinLbl.text = ""
        }
        
        if(self.aStruct?.products.count == 0){
            
            
            addItemBtn.isHidden = false
            let imageName = "Empty.png"
            let image = UIImage(named: imageName)
            
            
            
            img1.image = image
            //img2.image = image
            curPrice.text = "$00.00"
            prodName.text = "Add an Item"
            
            prodName2.text = "Add an Item"
            
            
            limLblReal.text = "$00.00"
            
            limField.placeholder = "$00.00"
            
            limField.text = ""
            
            asinLbl.text = ""
            
        }
        
        if(self.aStruct?.products.count ?? -1 > 0){
            addItemBtn.isHidden = true
            let url = URL(string: self.aStruct!.products[0].imageUrl as! String)
            
            
            //img2.image = UIImage(data: data)
            curPrice.text = "$" + String(self.aStruct!.products[0].price)
            //prodName.text = String(self.aStruct!.products[0].name)
            
            prodName2.text = String(self.aStruct!.products[0].name)
            
            
            limLblReal.text = "$" +  String(self.aStruct!.products[0].priceLimit) + "0"
            
            limField.placeholder = "$" +  String(self.aStruct!.products[0].priceLimit) + "0"
            
            limField.text = ""
            
            asinLbl.text = String(self.aStruct!.products[0].asin)
            let data = (try? Data(contentsOf: url!))!
            img1.image = BackgroundRemoval.init().removeBackground(image: UIImage(data: data)!)
        }
        
        
    }
    

    @IBAction func openWeb(_ sender: Any) {
        if let url = URL(string: "https://www.amazon.com/dp/" + asinLbl.text!) {
            UIApplication.shared.open(url)
        }
    }
    func hideElements(){
        box.isHidden = true
        priceNameLbl.isHidden = true
        priceLbl.isHidden = true
        limitLbl.isHidden = true
        textField.isHidden = true
        deleteBtn.isHidden = true
        updateBtn.isHidden = true
    }
    
    func showElements(){
        box.isHidden = false
        priceNameLbl.isHidden = false
        priceLbl.isHidden = false
        limitLbl.isHidden = false
        textField.isHidden = false
        deleteBtn.isHidden = false
        updateBtn.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        activityIndicator.startAnimating()
        limField.delegate = self
        //textField.delegate = self
        //textField.delegate = self
        //dismissBtn.isHidden = true
        //blur.isHidden = true
        token = defaults.string(forKey: "tokenString") ?? UIDevice.current.identifierForVendor?.uuidString as! String
        
        print("This is real token: " + token)
        
        //hideElements()
        
        
        
        
        print(productImgLinks)
        collectionViewOutlet.layer.cornerRadius = 5.0
        collectionViewOutlet.layer.masksToBounds = true
        collectionViewOutlet.dataSource = self
        collectionViewOutlet.delegate = self
        
        // add this line:
        
        
        //Pls Uncomment when I am done
        getCall()
        //resetDash()
        
        print("these are products: ")
        print(self.aStruct?.products)
        //print("this is the token: " + token)
        /*if(self.aStruct?.products == nil){
            
        }
        else
        
        {
            
            while(self.aStruct?.products[0].price == nil){
                
            }
            
            
        }
         */
        
        
        
        //print(self.aStruct!.products.count)
        
        //print(aStruct!.products.count)
        
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    func getCall() {
        
        //let deviceToken = (UIDevice.current.identifierForVendor?.uuidString)!
        // Create URL
        let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/get-products?page=0&limit=25&deviceToken=" + token)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        
        let group = DispatchGroup()
                    group.enter()
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
                
                group.leave()

                
                
                //print(self.aStruct?.products[0].price)
                //print(self.aStruct?.products[0].price)
                
            }
            
        }
        task.resume()
        
        group.notify(queue: .main) {
            
            //self.dismissBtn.isHidden = true
            //self.blur.isHidden = true
            //uncomment
            self.activityIndicator.stopAnimating()
            self.resetDash()
            self.collectionViewOutlet.reloadData()
            //self.hideElements()
                    }
        
    }
    @IBAction func btnpress(_ sender: Any) {
        print(self.aStruct?.products[0].price)
    }
    
    
    @IBAction func dismiss(_ sender: Any) {
        hideElements()
        blur.isHidden = true
        dismissBtn.isHidden = true
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

extension homePage: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
   }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
    
    
    
    
}



