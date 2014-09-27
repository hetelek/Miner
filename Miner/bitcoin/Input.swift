//
//  Input.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/15/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

struct Input : DataObjectProtocol
{
    var previousTransactionHash: NSData
    var previousTransactionOutIndex: UInt32
    var scriptLength: VariableLengthInteger
    var script: NSData
    var sequence: UInt32 = 0xFFFFFFFF
    
    init(rawData: NSData)
    {
        previousTransactionHash = NSData(bytes: rawData.bytes, length: 0x20)
        
        // get previous transaction index and script length
        self.previousTransactionOutIndex = 0
        rawData.getBytes(&previousTransactionOutIndex, range: NSMakeRange(0x20, 4))
        scriptLength = VariableLengthInteger(data: rawData, index: 0x24)
        
        // get script
        let scriptStartOffset = 0x24 + scriptLength.integerLength
        script = NSData(bytes: rawData.bytes.advancedBy(scriptStartOffset), length: Int(scriptLength.value))
        
        // get sequence
        rawData.getBytes(&sequence, range: NSMakeRange(scriptStartOffset + Int(scriptLength.value), 4))
    }
    
    var inputLength: UInt64
    {
        get
        {
            return 0x28 + UInt64(scriptLength.integerLength) + scriptLength.value
        }
    }
    
    var rawData: NSData
    {
        get
        {
            let dataBlock = DataBlock()
            
            // populate data block
            dataBlock.addSegment(previousTransactionHash)
            dataBlock.addSegment(previousTransactionOutIndex.littleEndian)
            dataBlock.addSegment(scriptLength)
            dataBlock.addSegment(script)
            dataBlock.addSegment(sequence)
            
            return dataBlock.rawData
        }
    }
}