//
//  AdvisorModel.swift
//  Psychic
//
//  Created by APPLE on 2/8/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import Foundation
class AdvisorModel
{
    var id = String()
    var legalNameOfIndividual = String()
    var serviceName = String()
    var profileImage = String()
    var isOnline = String()
    var rating = String()
    var liveChat = String()
    var threeMinuteVideo = String()
    
    
    
    init(id:String, legalNameOfIndividual:String,serviceName:String,  profileImage:String, isOnline:String,rating:String, liveChat:String,  threeMinuteVideo:String)
    {
        self.id = id
        self.legalNameOfIndividual = legalNameOfIndividual
        self.serviceName = serviceName
        self.profileImage = profileImage
        self.isOnline = isOnline
        self.rating = rating
        self.liveChat = liveChat
        self.threeMinuteVideo = threeMinuteVideo
 
    }
}




class FilterAdvisors{
    var name = String()
    var status = String()
    var userID = String()
    
    init(name:String, status:String, userID:String)
    {
        self.name = name
        self.status = status
        self.userID = userID
    }
}



