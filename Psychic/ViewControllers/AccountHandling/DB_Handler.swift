//
//  DB_Handler.swift
//  Washir
//
//  Created by APPLE on 3/5/18.
//  Copyright © 2018 SCC INFOTECH LLP. All rights reserved.
//

import UIKit
import CoreData

class DB_Handler: NSObject {
    
    //    please refer readme file point 4
    
    
    private class func getContext() -> NSManagedObjectContext
    {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        
        return delegate.persistentContainer.viewContext
    }

    
    class func saveFeatured(ad_desc: String, ad_id: String, ad_image: String, ad_name: String, ad_stars:String, ad_video:String, isOnline:String, liveChat:String, threeMinuteVideo:String) -> Bool
    {
        
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "ListOfAdvisors", in: context)
        
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(ad_desc, forKey: "ad_desc")
        manageObject.setValue(ad_id, forKey: "ad_id")
        manageObject.setValue(ad_image, forKey: "ad_image")
        manageObject.setValue(ad_name, forKey: "ad_name")
        manageObject.setValue(ad_stars, forKey: "ad_stars")
        manageObject.setValue(ad_video, forKey: "ad_video")
        manageObject.setValue(isOnline, forKey: "isOnline")
        manageObject.setValue(liveChat, forKey: "liveChat")
        manageObject.setValue(threeMinuteVideo, forKey: "threeMinuteVideo")
        do
        {
            try context.save()
            return true
            
        }catch
        {
            return false
        }
        
    }//Save Contact
    
    
    class func getFeatured() -> [ListOfAdvisors]?
    {
        
        let context = getContext()
        var location:[ListOfAdvisors]? = nil
        do
        {
            location =  try context.fetch(ListOfAdvisors.fetchRequest())
            return location
        }
        catch
        {
            return location
        }
        
    }// fetch Contact end here
    
    
 
    
    class func deleteAllRecords() {
        //getting context from your Core Data Manager Class
        let managedContext = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ListOfAdvisors")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            print("Old record deleted")
        } catch {
            print ("There is an error in deleting records")
        }
    }
    
    
    
    
    
}








