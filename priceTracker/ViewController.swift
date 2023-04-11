//
//  ViewController.swift
//  priceTracker
//
//  Created by Harshith Sadhu on 2/23/23.
//

import UIKit
import WebKit
import SwiftSoup

class ViewController: UIViewController {
    
    /*
     
     let body: [String: Any] = ["asin": "asdfasdfas", "name": "Apple","price": 45, "priceLimit": 40, "deviceToken": deviceToken, "imageUrl": "https://m.media-amazon.com/images/I/816o-n47S8L._AC_SX679_.jpg"]
     */

    @IBOutlet weak var limField: UITextField!
    
    var productInfo = ["asin": "CHHFDSDF",
                       "name": "",
                       "price": 0.5,
                       "priceLimit": 0.5, "success": false] as [String : Any]
    
    var token = ""
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var webView: WKWebView!
    var stringLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBtn.layer.cornerRadius = 10
        webView.load(URLRequest(url: URL(string: "https://www.amazon.com/")!))
        // Do any additional setup after loading the view.
        
        
    }
    @IBAction func btn(_ sender: Any) {
        
        var currentURL = webView.url
        print("Current URL: ")
        print(currentURL)
        stringLink = currentURL!.absoluteString
        
        //getCall()
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
        
                // get the price
                let price = try document.select(".a-price-whole").first()?.text() ?? "N/A"
                let price2 = try document.select(".a-price-fraction").first()?.text() ?? "N/A"
                print("Price: \(price + price2)")
        self.productInfo["price"] = Float(price + price2)

                // get the review count
                let reviewCount = try document.select("#acrCustomerReviewText").text()
                print("Review Count: \(reviewCount)")

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
    
    
    func apiCall(){
        
        
        guard let url = URL(string: "https://jhs-plutus.uc.r.appspot.com/add-product") else{
            return
        }
                
        
        
        var request = URLRequest(url: url)
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let body: [String: String] = ["link": stringLink]
        
        let deviceToken = UIDevice.current.identifierForVendor?.uuidString
        
        

        
        let body: [String: Any] = ["asin": productInfo["asin"], "name": productInfo["name"],"price": productInfo["price"], "priceLimit": productInfo["priceLimit"], "deviceToken": deviceToken, "imageUrl": "https://m.media-amazon.com/images/I/816o-n47S8L._AC_SX679_.jpg"]
        
        let body2: [String: Any] = ["page": 1, "limit": 3, "deviceToken": deviceToken, "sortBy": "name", "sortOrder": "asc"]
        
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        // Make the request
        let task = URLSession.shared.dataTask(with: request){ data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                
                
                
                
            }
            catch{
                print(error)
            }
            
        }
        
        performSegue(withIdentifier: "homeSegue", sender: self)
        task.resume()
        
        
        
        
        
        
        
    }
    

}

