//
//  AdvisorTerms&Condtions.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AdvisorTerms_Condtions: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var conditionSwitch: UISwitch!
    @IBOutlet weak var nextBtn: UIButton!
    let titles = ["Some Heading", "Vokalia and Consonantia", "We are socialized"]
    
    let details = ["Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. ", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?"]
    
    var text = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Advisor Terms & Conditions"
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        nextBtn.isUserInteractionEnabled = false
        gettermscondition()
        
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headings") as! AdvisorTermsCondtionsCell
        cell.titleLabel.text = ""
        cell.detailsLabel.text = self.text
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    
    
    func gettermscondition()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"gettermscondition")!
            var parameters = Parameters()
            
            
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    let a = JSON(responseData.result.value)
                    self.text = "\(a["Result"][0]["text"])"
                    self.tableView.reloadData()
                    self.nextBtn.isUserInteractionEnabled = true
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
    
    
    
    @IBAction func nextBtn(_ sender: Any)
    {
        let value = conditionSwitch.isOn
        
        
        if value == true
        {
            performSegue(withIdentifier: "tickScreen", sender: nil)
        }
        else
        {
            showPopup(msg: "You have to accept the Terms and Conditions", sender: self)
        }
        
    }
    
    
}
