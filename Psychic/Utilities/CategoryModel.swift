//
//  CategoryModel.swift
//  Psychic
//
//  Created by APPLE on 12/31/18.
//  Copyright © 2018 Jobesk. All rights reserved.
//

import Foundation
class CategoryModel {
    
    
    var imageAddress = String()
    var title = String()
    var status = String()
    var catID = String()
    
    
    init(catImage:String, catTitle:String, ID:String) {
        
        self.imageAddress = catImage
        self.title = catTitle
        self.status = "0"
        self.catID = ID
        
    }
    
    
    func getStaus ()->String
    {
        return self.status
    }
    
    func setStatus (value:String)
    {
        self.status = value
    }
    
    
    func getID ()->String
    {
        return self.catID
    }
    
    
    
    
    func getTitle ()->String
    {
        return self.title
    }
    func getImageAddress () -> String
    {
    return self.imageAddress
    }
    
    
}
