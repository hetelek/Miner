//
//  BlockHeader.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/14/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

struct BlockHeader : DataObjectProtocol
{
    var version: UInt32
    var previousBlockHash: NSData
    var merkleRootHash: NSData?
    var timestamp: UInt32
    var bits: UInt32
    var nonce: UInt32
    
    init(rawData: NSData)
    {
        self.version = 0
        self.timestamp = 0
        self.bits = 0
        self.nonce = 0
        
        // parse data into block header properties
        rawData.getBytes(&version, range: NSMakeRange(0, 0x4))
        self.previousBlockHash = NSData(bytes: rawData.bytes.advancedBy(0x4), length: 0x20)
        self.merkleRootHash = NSData(bytes: rawData.bytes.advancedBy(0x24), length: 0x20)
        rawData.getBytes(&timestamp, range: NSMakeRange(0x44, 0x4))
        rawData.getBytes(&bits, range: NSMakeRange(0x48, 0x4))
        rawData.getBytes(&nonce, range: NSMakeRange(0x4C, 0x4))
    }
    
    var rawData: NSData
    {
        get
        {
            let dataBlock = DataBlock()
            
            // populate data block
            dataBlock.addSegment(version)
            dataBlock.addSegment(previousBlockHash)
            dataBlock.addSegment(merkleRootHash!)
            dataBlock.addSegment(timestamp)
            dataBlock.addSegment(bits)
            dataBlock.addSegment(nonce)
            
            return dataBlock.rawData
        }
    }
}