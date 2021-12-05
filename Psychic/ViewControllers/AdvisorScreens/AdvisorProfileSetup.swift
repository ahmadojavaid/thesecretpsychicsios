//
//  AdvisorProfileSetup.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import UIKit

class AdvisorProfileSetup: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextBtn: UIButton!
    let details = ["Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. ", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?", "Have you ever finally just gave in to the temptation and read your horoscope in the newspaper on Sunday morning?"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.title = "Advisor Profile Setup"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80.0
//        nextBtn.isUserInteractionEnabled = false
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "advisor") as! AdvisorProfileSetupCell
        
        cell.titleLabel.text = self.details[indexPath.row]
        
        
        cell.selectionStyle = .none
        return cell
    }


}
