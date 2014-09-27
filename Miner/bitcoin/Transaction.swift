//
//  Transaction.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/15/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

class Transaction : DataObjectProtocol
{
    var version: UInt32 = 1
    var inputCount: VariableLengthInteger?
    var inputs: [Input] = []
    var outputCount: VariableLengthInteger?
    var outputs: [Output] = []
    var lockTime: Int32 = 0
    
    init() { }
    required init(rawData: NSData)
    {
        rawData.getBytes(&version, range: NSMakeRange(0, 0x4))

        // parse inputs
        inputCount = VariableLengthInteger(data: rawData, index: 0x4)
        var currentPosition = 0x4 + inputCount!.integerLength
        
        let inputCountValue = inputCount!.value
        for var i: UInt64 = 0; i < inputCountValue; i++
        {
            let input = Input(rawData: rawData.subdataWithRange(NSMakeRange(currentPosition, rawData.length - currentPosition)))
            inputs.append(input)
            
            currentPosition += Int(input.inputLength)
        }
        
        // parse output
        outputCount = VariableLengthInteger(data: rawData, index: currentPosition)
        currentPosition += outputCount!.integerLength
        
        let outputCountValue = outputCount!.value
        for var i: UInt64 = 0; i < outputCountValue; i++
        {
            let output = Output(rawData: rawData.subdataWithRange(NSMakeRange(currentPosition, rawData.length - currentPosition)))
            outputs.append(output)
            
            currentPosition += Int(output.outputLength)
        }
        
        rawData.getBytes(&lockTime, range: NSMakeRange(currentPosition, 0x4))
    }
    
    var transactionLength: UInt64
    {
        get
        {
            // calculate total output length
            var totalOutputLength = 0
            for output in outputs
            {
                totalOutputLength += Int(output.outputLength)
            }
            
            // calculate total input length
            var totalInputLength = 0
            for input in inputs
            {
                totalInputLength += Int(input.inputLength)
            }
            
            // add magic, size, variable integers, and total lengths
            return 0x8 + inputCount!.integerLength + outputCount!.integerLength + totalOutputLength + totalInputLength
        }
    }
    
    var rawData: NSData
    {
        get
        {
            let dataBlock = DataBlock()
            
            dataBlock.addSegment(version)
            
            // add input count
            if let inputCountUnwrapped = inputCount
            {
                dataBlock.addSegment(inputCountUnwrapped)
            }
            else
            {
                dataBlock.addSegment(VariableLengthInteger(signedInt: inputs.count))
            }
            
            // add inputs
            for input in inputs
            {
                dataBlock.addSegment(input)
            }
            
            // add output count
            if let outputCountUnwrapped = outputCount
            {
                dataBlock.addSegment(outputCountUnwrapped)
            }
            else
            {
                dataBlock.addSegment(VariableLengthInteger(signedInt: outputs.count))
            }
            
            // add outputs
            for output in outputs
            {
                dataBlock.addSegment(output)
            }
            
            // add lock time
            dataBlock.addSegment(lockTime)
            
            return dataBlock.rawData
        }
    }
}