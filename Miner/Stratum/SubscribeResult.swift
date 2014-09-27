//
//  SubscribeResult.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/20/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

struct SubscribedNotification
{
    var name: String
    var hash: String
}

class SubscribeResult
{
    var subscribedNotifications: [SubscribedNotification] = []
    var extraNonce1: String!
    var extraNonce2Size: Int!
    
    class func attemptParseWithResponse(response: RPCResponse) -> SubscribeResult?
    {
        if let resultArray = response.result as? [AnyObject]
        {
            // if the array count != 3, then it cannot be a subscribe result
            if resultArray.count != 3
            {
                return nil
            }
            
            let subscribeResult = SubscribeResult()
            
            // parse the data in the array (subscribed services(name, hash), extraNonce1, extraNonce2Size)
            let subscribedNotificationsArray = resultArray[0] as [AnyObject]
            for subscribedNotification in subscribedNotificationsArray
            {
                let name = subscribedNotification[0] as String
                let hash = subscribedNotification[1] as String
                
                subscribeResult.subscribedNotifications.append(SubscribedNotification(name: name, hash: hash))
            }
            
            subscribeResult.extraNonce1 = resultArray[1] as String
            subscribeResult.extraNonce2Size = resultArray[2] as? Int
            
            return subscribeResult
        }
        
        return nil
    }
}