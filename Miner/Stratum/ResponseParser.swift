//
//  ResponseParser.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/20/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

let RESPONSE_SEPERATOR = NSData(bytes: UnsafePointer<UInt8>([0x0A]), length: 1)
class ResponseParser
{
    class func parseResponse(response: NSData) -> [AnyObject]
    {
        // create our array
        var parsedResponses: [AnyObject] = []
        
        // get the length
        let responseLength = response.length
        
        // setup start index, get the end index of the first dictionary
        var startIndex = 0
        var endIndex = response.rangeOfData(RESPONSE_SEPERATOR, options: NSDataSearchOptions.allZeros, range: NSMakeRange(0, responseLength)).location
        
        // parse the data
        while endIndex <= responseLength
        {
            // get the subdata
            let currentDictionaryData = response.subdataWithRange(NSMakeRange(startIndex, endIndex - startIndex))
            
            // convert it to an object
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(currentDictionaryData, options: NSJSONReadingOptions.AllowFragments, error: nil)

            // if it's a NSDictionary, append it
            if let dictionaryObject = jsonObject as? NSDictionary
            {
                #if DEBUG
                println(dictionaryObject)
                #endif
                    
                if dictionaryObject.objectForKey("params") != nil
                {
                    parsedResponses.append(RPCRequest(dictionary: dictionaryObject))
                }
                else
                {
                    parsedResponses.append(RPCResponse(dictionary: dictionaryObject))
                }
            }
            
            // update start/end indexes
            startIndex = endIndex + 1
            
            let searchRange = NSMakeRange(startIndex, responseLength - startIndex)
            endIndex = response.rangeOfData(RESPONSE_SEPERATOR, options: NSDataSearchOptions.allZeros, range: searchRange).location
        }
        
        // return the dictionaries
        return parsedResponses
    }
}