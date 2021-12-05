//
//  IAP_Service.swift
//  Psychic
//
//  Created by APPLE on 3/25/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import Foundation
import StoreKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class IAP_Service: NSObject
{
    
    private override init(){}
    static let shared = IAP_Service()
    let paymentQueue = SKPaymentQueue.default()

    var products = [SKProduct]()
    
    
    func getProducts ()
    {
        let products : Set = [ FIRST_PRODUCT, SECOND_PRODUCT, THIRD_PRODUCT, FOURTH_PRODUCT, FIVTH_PRODUCT]
        
        
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
        
    }
    
    
    func purchase(id:String)
    {
        
        let productToPurchase = products.filter({$0.productIdentifier == id}).first
        let payment = SKPayment(product: productToPurchase!)
        paymentQueue.add(payment)
    }
    
}

extension IAP_Service:SKProductsRequestDelegate
{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
    {
        
        print("Total products are \(response.products.count)")
        self.products = response.products
        for product in response.products
        {
            print(product.localizedTitle)
        }
    }
    
    
}



extension IAP_Service: SKPaymentTransactionObserver
{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transation in transactions
        {
            print(transation.transactionState.status(), transation.payment.productIdentifier)
            
            if transation.transactionState.status() == "purchased"
            {
                myCall(id: transation.payment.productIdentifier)
            }
            
            switch transation.transactionState
            {
            case .purchasing:
                print("Bought product is \(transation.payment.productIdentifier)")
                break
                
            default:
                queue.finishTransaction(transation)
            
            }
        }
        
        
        
    }
}

extension SKPaymentTransactionState
{
    func status () -> String
    {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased:
            return "purchased"
        case .purchasing: return "puchasing"
            
            
        case .restored: return "restored"
        default:
            
            return "No Status"
        }
     
        
    }
}

func myCall(id:String)
{
    
    
    if id == FIRST_PRODUCT
    {
        BOUGHT_PRODUCT = "1"
    } else if id == SECOND_PRODUCT
    {
        BOUGHT_PRODUCT = "2"
    } else if id == THIRD_PRODUCT
    {
        BOUGHT_PRODUCT = "3"
    } else if id == FOURTH_PRODUCT
    {
        BOUGHT_PRODUCT = "4"
    } else if id == FIVTH_PRODUCT
    {
        BOUGHT_PRODUCT = "5"
    }
    ONCE_DONE = "1"
    if BUY_SCREEN == "FIRST"
    {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePayment"), object: nil)
    }
    else
    {
        
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updatePaymentSecond"), object: nil)
    }
    
}



