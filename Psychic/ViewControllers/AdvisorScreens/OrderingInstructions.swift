//
//  OrderingInstructions.swift
//  Psychic
//
//  Created by APPLE on 1/1/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class OrderingInstructions: UIViewController {

    @IBOutlet weak var orderInst: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.title = "Ordering Instructions"
        orderInst.toolbarPlaceholder = "Order Instructions..."
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func updateOrder(_ sender: Any)
    {
        let order = orderInst.text!
        
        if order.isEmpty
        {
            showPopup(msg: "Please type in order instructions", sender: self)
        }
        else
        {
                orderInstructions(instructionForOrder: order)
        }
        
        
    }
    func orderInstructions(instructionForOrder:String)
    {
        if Reach.isConnectedToNetwork()
        {
            
            let id = DEFAULTS.string(forKey: "user_id")!
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"updateAdvisorInfo/"+id)!
            var parameters = Parameters()
            
            parameters = ["instructionForOrder":instructionForOrder]
            
            Alamofire.request(baseurl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    
                    let statusCode = "\(a["statusCode"])"
                    
                    if statusCode == "1"
                    {
                        self.performSegue(withIdentifier: "order", sender: nil)
                    }
                    else
                    {
                        showPopup(msg: "Please try later", sender: self)
                    }
                    
                    
                    
                    
                    print(a)
                    
                    
                }
                else
                {
                    print("There was Error")
                    print("Error is \(responseData.result.error)")
                    showPopup(msg: "Please try later", sender: self)
                }
            }// Alamofire ends here
            
        }
        else
        {
            showPopup(msg: "Internet could not connect", sender: self)
            
        }
    }

}
