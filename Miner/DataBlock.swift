//
//  DataBlock.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/16/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

class DataBlock : DataObjectProtocol
{
    var dataSegments: [DataBlockSegment] = []
    var currentPosition: Int = 0
    
    init() {}
    required init(rawData: NSData)
    {
        addSegment(rawData)
    }
    
    func addSegment(data: NSData)
    {
        dataSegments.append(DataBlockSegment(data: data))
    }
    
    func addSegment(dataObject: DataObjectProtocol)
    {
        dataSegments.append(DataBlockSegment(dataObject: dataObject))
    }
    
    func addSegment(unsignedInt: UInt32)
    {
        dataSegments.append(DataBlockSegment(unsignedInt32: unsignedInt))
    }
    
    func addSegment(signedInt: Int32)
    {
        dataSegments.append(DataBlockSegment(signedInt32: signedInt))
    }
    
    func addSegment(unsignedInt: UInt64)
    {
        dataSegments.append(DataBlockSegment(unsignedInt64: unsignedInt))
    }
    
    func addSegment(signedInt: Int64)
    {
        dataSegments.append(DataBlockSegment(signedInt64: signedInt))
    }
    
    var rawData: NSData
    {
        get
        {
            var rawDataBlocks: [NSData] = []
            
            // calculate the size of the data
            var dataLength = 0
            for dataSegment in dataSegments
            {
                switch dataSegment.type
                {
                case DataBlockSegmentType.SignedInt32, DataBlockSegmentType.UnsignedInt32:
                    dataLength += 4
                    break
                case DataBlockSegmentType.SignedInt64, DataBlockSegmentType.UnsignedInt64:
                    dataLength += 8
                    break
                case DataBlockSegmentType.Data:
                    dataLength += dataSegment.data.length
                    rawDataBlocks.append(dataSegment.data)
                    break
                case DataBlockSegmentType.DataObject:
                    let rawData = dataSegment.dataObject.rawData
                    dataLength += rawData.length
                    rawDataBlocks.append(rawData)
                    break
                }
            }
            
            // construct the data
            var data = NSMutableData(length: dataLength)
            var currentDataIndex = 0
            var currentOffset = 0
            for dataSegment in dataSegments
            {
                switch dataSegment.type
                    {
                case DataBlockSegmentType.SignedInt32:
                    data.replaceBytesInRange(NSMakeRange(currentOffset, 0x4), withBytes: UnsafePointer<Int32>([dataSegment.signedInt32]))
                    currentOffset += 0x4
                    break
                case DataBlockSegmentType.UnsignedInt32:
                    data.replaceBytesInRange(NSMakeRange(currentOffset, 0x4), withBytes: UnsafePointer<UInt32>([dataSegment.unsignedInt32]))
                    currentOffset += 0x4
                    break
                case DataBlockSegmentType.SignedInt64:
                    data.replaceBytesInRange(NSMakeRange(currentOffset, 0x8), withBytes: UnsafePointer<Int64>([dataSegment.signedInt64]))
                    currentOffset += 0x8
                    break
                case DataBlockSegmentType.UnsignedInt64:
                    data.replaceBytesInRange(NSMakeRange(currentOffset, 0x8), withBytes: UnsafePointer<UInt64>([dataSegment.unsignedInt64]))
                    currentOffset += 0x8
                    break
                case DataBlockSegmentType.Data, DataBlockSegmentType.DataObject:
                    let rawData = rawDataBlocks[currentDataIndex++]
                    data.replaceBytesInRange(NSMakeRange(currentOffset, rawData.length), withBytes: rawData.bytes)
                    currentOffset += rawData.length
                    break
                }
            }
            
            return data
        }
    }
}