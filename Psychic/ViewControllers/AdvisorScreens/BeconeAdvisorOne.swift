//
//  BeconeAdvisorOne.swift
//  Psychic
//
//  Created by APPLE on 12/28/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class BeconeAdvisorOne: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
//    let titles = ["Some Heading", "Vokalia and Consonantia", "We are socialized"]
//
//    let details = ["Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. ", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?"]
    
    
    var text = String()
    
    @IBOutlet weak var tableVIew: UITableView!
    
    @IBOutlet weak var nextBTn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Back"
        self.title = "Becoming an Advisor"
        
        tableVIew.estimatedRowHeight = 80.0
        tableVIew.rowHeight = UITableView.automaticDimension
        tableVIew.delegate = self
        tableVIew.dataSource = self
        nextBTn.isUserInteractionEnabled = false
        getbecomeAdvisor()
    }
    
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVIew.dequeueReusableCell(withIdentifier: "headings") as! BecomeAdvisorOneCell

        cell.titleLabel.text = ""
        cell.detailsLabel.text = self.text
        
        cell.selectionStyle = .none
  
        return cell
    }
    
    
    
    
    func getbecomeAdvisor()
    {
        if Reach.isConnectedToNetwork()
        {
            
            SVProgressHUD.show(withStatus: LOADING_STRING)
            let baseurl = URL(string:BASE_URL+"getbecomeAdvisor")!
            var parameters = Parameters()
            
            
            parameters = [:]
            Alamofire.request(baseurl, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON{ (responseData) -> Void in
                if((responseData.result.value) != nil)
                {
                    SVProgressHUD.dismiss()
                    
                    
                    let a = JSON(responseData.result.value)
                    self.text = "\(a["Result"][0]["text"])"
                    self.tableVIew.reloadData()
                    
                    self.nextBTn.isUserInteractionEnabled = true
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
