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
        apiCall()
        scrapeAmazonProduct(linkThing: stringLink)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "homePage") as! homePage
        
        controller.productImgLinks.append("https://media.wbur.org/wp/2=020/05/pencil-standardized-test-1000x667.jpg")
        
        controller.productData.append("Testt")
        
        print("current items")
        print(controller.productData)
        
        
        performSegue(withIdentifier: "homeSegue", sender: self)
        
        
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

                // get the product rating
                let rating = try document.select(".a-icon-star-small").first()?.text() ?? "N/A"
                print("Product Rating: \(rating)")
        
                // get the price
                let price = try document.select(".a-price-whole").first()?.text() ?? "N/A"
                let price2 = try document.select(".a-price-fraction").first()?.text() ?? "N/A"
                print("Price: \(price + price2)")
        

                // get the review count
                let reviewCount = try document.select("#acrCustomerReviewText").text()
                print("Review Count: \(reviewCount)")

                // get the product availability
                let availability = try document.select("#availability").text()
                print("Product Availability: \(availability)")
            } catch {
                print("Error: \(error)")
            }
        }
        
        // start the data task to fetch the HTML content
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

        
        let body: [String: Any] = ["asin": "asdfasdfas", "name": "Apple","price": 45, "priceLimit": 40, "deviceToken": deviceToken]
        
        
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
        task.resume()
        
        
        
        
        
        
        
    }
    

}

