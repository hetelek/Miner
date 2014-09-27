//
//  DataBlockSegment.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/16/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

enum DataBlockSegmentType
{
    case DataObject
    case Data
    case SignedInt32
    case UnsignedInt32
    case SignedInt64
    case UnsignedInt64
}

struct DataBlockSegment
{
    var type: DataBlockSegmentType
    var dataObject: DataObjectProtocol!
    var data: NSData!
    var signedInt32: Int32!
    var unsignedInt32: UInt32!
    var signedInt64: Int64!
    var unsignedInt64: UInt64!
    
    init(dataObject: DataObjectProtocol)
    {
        self.type = DataBlockSegmentType.DataObject
        self.dataObject = dataObject
    }
    
    init(data: NSData)
    {
        self.type = DataBlockSegmentType.Data
        self.data = data
    }
    
    init(signedInt32: Int32)
    {
        self.type = DataBlockSegmentType.SignedInt32
        self.signedInt32 = signedInt32
    }
    
    init(unsignedInt32: UInt32)
    {
        self.type = DataBlockSegmentType.UnsignedInt32
        self.unsignedInt32 = unsignedInt32
    }
    
    init(signedInt64: Int64)
    {
        self.type = DataBlockSegmentType.SignedInt64
        self.signedInt64 = signedInt64
    }
    
    init(unsignedInt64: UInt64)
    {
        self.type = DataBlockSegmentType.UnsignedInt64
        self.unsignedInt64 = unsignedInt64
    }
}