//
//  Output.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/15/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

struct Output : DataObjectProtocol
{
    var value: UInt64
    var scriptLength: VariableLengthInteger
    var script: NSData
    
    init(rawData: NSData)
    {
        self.value = 0
        rawData.getBytes(&value, range: NSMakeRange(0, 0x8))
        
        // get script length and script data
        scriptLength = VariableLengthInteger(data: rawData, index: 0x8)
        script = NSData(bytes: rawData.bytes.advancedBy(0x8 + scriptLength.integerLength), length: Int(scriptLength.value))
    }
    
    var outputLength: UInt64
    {
        get
        {
            return 0x8 + UInt64(scriptLength.integerLength) + scriptLength.value
        }
    }
    
    var rawData: NSData
    {
        get
        {
            let dataBlock = DataBlock()
            
            // populate data block
            dataBlock.addSegment(value)
            dataBlock.addSegment(scriptLength)
            dataBlock.addSegment(script)
            
            return dataBlock.rawData
        }
    }
}