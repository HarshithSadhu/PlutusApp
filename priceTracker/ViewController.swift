//
//  ViewController.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit
import WebKit
import SwiftSoup
import NVActivityIndicatorView

class ViewController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var helpText: UIImageView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var box: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
     
    @IBOutlet weak var activityIndicator2: NVActivityIndicatorView!
    /*
     let body: [String: Any] = ["asin": "asdfasdfas", "name": "Apple","price": 45, "priceLimit": 40, "deviceToken": deviceToken, "imageUrl": "https://m.media-amazon.com/images/I/816o-n47S8L._AC_SX679_.jpg"]
     */

    @IBOutlet weak var limField: UITextField!
    
    let defaults = UserDefaults.standard
    
    var productInfo = ["asin": "",
                       "name": "",
                       "price": 0.5,
                       "priceLimit": 0.5, "imgURL":"", "success": false] as [String : Any]
    
    var isClicked = false
    
    var num = 0
    var token = ""
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    var stringLink = ""
    override func viewDidLoad() {
        spinner.isHidden = true
        super.viewDidLoad()
        //errorLbl.isHidden = true
        //box.isHidden = true
        token = defaults.string(forKey: "tokenString") ?? ""
        
        limField.delegate = self
        
        addBtn.layer.cornerRadius = 10
        webView.load(URLRequest(url: URL(string: "https://www.amazon.com/")!))
        // Do any additional setup after loading the view.
        print("this is the token: " + token)
        
        
    }
    
    func showElements(){
        backBtn.isHidden = false
        helpText.isHidden = false
        
        
    }
    @IBAction func hideTing(_ sender: Any) {
        isClicked = !isClicked
        if(isClicked){
            showElements()
        }
        if(isClicked == false){
            hideElements()
        }
    }
    @IBAction func help(_ sender: Any) {
        showElements()
    }
    
    func hideElements(){
        backBtn.isHidden = true
        helpText.isHidden = true
        
        
    }
    
    
    @IBOutlet weak var errorString: UILabel!
    @IBAction func btn(_ sender: Any) {
        
        limField.endEditing(true)
        
        activityIndicator2.isHidden = false
        activityIndicator2.startAnimating()
        
        var currentURL = webView.url
        print("Current URL: ")
        print(currentURL)
        stringLink = currentURL!.absoluteString
        
        //spinner.isHidden = false
        //spinner.startAnimating()
        //getCall()
        
        //Uncomment whenever possible
        scrapeAmazonProduct(linkThing: stringLink)
        
       
        
        
        
        
        
        
        
        
    }
    
    
   
    
    
    func scrapeAmazonProduct(linkThing:String) {
        // import required libraries
        

        // specify the URL of the product page
        let urlString = linkThing

        // create a URL object from the URL string
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }

        // create a URLSession and data task to fetch the HTML content asynchronously
        let session = URLSession.shared
        
        let group = DispatchGroup()
            group.enter()
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Error: no data returned")
                return
            }
            
            do {
                // convert the data to a string
                let htmlContent = String(data: data, encoding: .utf8)
                
                // parse the HTML content using SwiftSoup
                let document = try SwiftSoup.parse(htmlContent ?? "")
                
                // get the title of the product
                let title = try document.select("#productTitle").text()
                print("Product Title: \(title)")
        self.productInfo["name"] = title
                // get the product rating
                let rating = try document.select(".a-icon-star-small").first()?.text() ?? "N/A"
                print("Product Rating: \(rating)")
        
        
        // get the ASIN of the product
                    let asin = try document.select("input[name='ASIN']").first()?.attr("value") ?? "N/A"
                    print("ASIN: \(asin)")
        self.productInfo["asin"] = asin
        
        
        
                // get the price
                let price = try document.select(".a-price-whole").first()?.text() ?? "N/A"
                let price2 = try document.select(".a-price-fraction").first()?.text() ?? "N/A"
                print("PriceThing: \(price + price2)")
        let priceRaw = (price + price2)
        
        let priceNew = priceRaw.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        self.productInfo["price"] = Float(priceNew)

                // get the review count
                let reviewCount = try document.select("#acrCustomerReviewText").text()
                print("Review Count: \(reviewCount)")

        
        
        // get the image URL of the product
                    let imageUrl = try document.select("#imgTagWrapperId img").first()?.attr("src") ?? "N/A"
                    print("Image URL: \(imageUrl)")
        self.productInfo["imgURL"] = imageUrl
        
        
                // get the product availability
                let availability = try document.select("#availability").text()
                print("Product Availability: \(availability)")
        group.leave()
        self.productInfo["success"] = true
            } catch {
                print("Error: \(error)")
            }
        }
        
        // start the data task to fetch the HTML content
        
        task.resume()
        
        
        productInfo["priceLimit"] = Float(limField.text!)
        
        group.notify(queue: .main) {
            self.apiCall()
            }
       
        
        
        
        
        
        
    }
    
    
    
    func getCall(){
        
        // Create URL
        let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/get-products?page=0&limit=3&deviceToken=Sullivan")
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
            }
            
        }
        task.resume()
        
        
        
    }
    
    func segueToNext(){
        num = 1
    }
    
    var shouldWait = false
    
    func apiCall(){
        
        
        guard let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/add-product") else{
            return
        }
                
        
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let body: [String: String] = ["link": stringLink]
        
        //let deviceToken = UIDevice.current.identifierForVendor?.uuidString
        
        

        
        let body: [String: Any] = ["asin": productInfo["asin"], "name": productInfo["name"],"price": productInfo["price"], "priceLimit": productInfo["priceLimit"], "deviceToken": token, "imageUrl": productInfo["imgURL"]]
        
        let body2: [String: Any] = ["page": 1, "limit": 3, "deviceToken": token, "sortBy": "name", "sortOrder": "asc"]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let group = DispatchGroup()
            group.enter()
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                //print("SUCCESS: \(response)")
                
                
                let jsonObject: [String: Any] = ["success": true]
                
                let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
                
                let response2 = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                //print("SUCCESS: \(response2)")
                
                let jsonString = String(data: jsonData, encoding: .utf8)
                let jsonString2 = String(data: data, encoding: .utf8)
                
                print(jsonString)
                print("then")
                print(jsonString2)
                
                if(jsonString != jsonString2){
                    
                    self.shouldWait = true
                    
                }
                /*
                if(response as! String == "error = \"Invalid ASIN\""){
                    self.box.isHidden = false
                    self.errorLbl.isHidden = false
                }
                 */
                self.segueToNext()
                
                group.leave()
            }
            
            
            catch{
                
                print(error)
            }
            
        }
        
        
        task.resume()
        
        
        group.notify(queue: .main) {
            
            if(self.shouldWait){
                
                
                self.errorString.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.performSegue(withIdentifier: "homeSegue", sender: self)
                }
                
            }
            
            else{
                self.errorString.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.performSegue(withIdentifier: "homeSegue", sender: self)
                }
            }
            
           
            
            
            
            
            
            
            }
        
        
        
        
        
        
        
        
    }
    
    
    

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
}
