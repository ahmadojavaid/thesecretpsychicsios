//
//  ChatMsgs.swift
//  Psychic
//
//  Created by APPLE on 1/16/19.
//  Copyright © 2019 Jobesk. All rights reserved.
//

import Foundation
class ChatMsgs {
    
    var sentTo = String()
    var sentBy = String()
    var updated_at = String()
    var msg = String()
    
    init(sentTo:String,sentBy:String, updated_at:String, msg:String)
    {
        self.sentTo = sentTo
        self.sentBy = sentBy
        self.updated_at = updated_at
        self.msg = msg
    }
    
    
    
    
    
    
    
}
