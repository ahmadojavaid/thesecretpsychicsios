//
//  AllWithdrawrequests.swift
//  Psychic
//
//  Created by APPLE on 3/29/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AllWithdrawrequests: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var revnues = JSON()
    var st = 0
    var oneValue = JSON()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.backgroundView = .none
        tableView.backgroundColor = .clear
        getPaymentDetails()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func backBtn(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
            return self.revnues.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revnueCell") as! RevnueCell
        cell.amountValue.text = "£ \(self.revnues[indexPath.row]["credit"])"
        cell.refType.text = "\(self.revnues[indexPath.row]["refrence"])"
        
        let fulltime: String = "\(self.revnues[indexPath.row]["created_at"])"
        let fullNameArr = fulltime.components(separatedBy: " ")
        
        let dateString = fullNameArr[0] // change to your date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let goodDate = dateFormatter.string(from: date!)
        
        print("The Good Date is \(goodDate)")
        let dateAsString = fullNameArr[1]
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let time = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: time!)
        
        
        cell.dateLabel.text = "\(Date12) \(goodDate)"
        
        
        
        
        cell.selectionStyle = .none
        cell.backgroundView = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.oneValue = self.revnues[indexPath.row]
        self.performSegue(withIdentifier: "oneDetail", sender: nil)
    }
    
    
    
    func getPaymentDetails()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let id = DEFAULTS.string(forKey: "user_id")!
            let baseurl = URL(string:BASE_URL+"payment?advisorId="+id)!
            var parameters = Parameters()
            
            
            parameters = [:]
            
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    print("One Advisor Details..........")
                    let a = JSON(responseData.result.value)
                    print(a)
                    let statusCode  = "\(a["statusCode"])"

                    if statusCode == "1"
                    {
                        self.revnues = a["paymentHistory"]
                        self.tableView.reloadData()
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
            showPopup(msg: "Could not conenct to Internet", sender: self)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "oneDetail"
        {
            let vc = segue.destination as! OneRevenue
            vc.oneValue = self.oneValue
        }
    }

}
