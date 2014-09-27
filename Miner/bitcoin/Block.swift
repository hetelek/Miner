//
//  Block.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/14/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

let BLOCK_MAGIC: UInt32 = 0xD9B4BEF9

class Block : DataObjectProtocol
{
    var magic: UInt32 = BLOCK_MAGIC
    var size: UInt32?
    var header: BlockHeader
    var transactionCounter: VariableLengthInteger?
    var transactions: [Transaction] = []
    
    init(transactions: [Transaction], header: BlockHeader)
    {
        self.transactions = transactions
        self.transactionCounter = VariableLengthInteger(signedInt: transactions.count)
        
        self.header = header
    }
    
    required init(rawData: NSData)
    {
        // get magic and size
        rawData.getBytes(&magic, range: NSMakeRange(0, 0x4))
        rawData.getBytes(&size, range: NSMakeRange(0x4, 0x4))
        
        // assert the magic
        assert(magic == BLOCK_MAGIC, "Invalid magic")
        
        // parse the block header (0x8 - 0x58)
        let rawHeaderData = NSData(bytes: rawData.bytes.advancedBy(0x8), length: 0x50)
        header = BlockHeader(rawData: rawHeaderData)
        
        // get the transaction count, increment position
        transactionCounter = VariableLengthInteger(data: rawData, index: 0x58)
        var currentPosition = 0x58 + transactionCounter!.integerLength
        
        // read all transactions
        let transactionCounterValue = transactionCounter!.value
        for var i: UInt64 = 0; i < transactionCounterValue; i++
        {
            let transaction = Transaction(rawData: rawData.subdataWithRange(NSMakeRange(currentPosition, rawData.length - currentPosition)))
            transactions.append(transaction)
            
            currentPosition += Int(transaction.transactionLength)
        }
    }
    
    private func calculateMerkleRoot() -> NSData?
    {
        // code based off of:
        // https://github.com/bitcoin/bitcoin/blob/2ec82e94e6b49a0e74243559b96ee736c0c54de7/src/core.cpp#L227
        
        // create start tree (the hashes we've been given)
        var merkleTree = [NSData]()
        for transaction in transactions
        {
            let transactionRawData = transaction.rawData
            merkleTree.append(Cryptography.doubleSha256HashData(transactionRawData.bytes, length: UInt32(transactionRawData.length)))
        }
        
        // calculate the rest of the tree
        var j = 0
        for (var nSize = merkleTree.count; nSize > 1; nSize = (nSize + 1) / 2)
        {
            for (var i = 0; i < nSize; i += 2)
            {
                var dataToHash: NSData
                
                let currentTransactionHash = merkleTree[j + i]
                
                if i + 1 > nSize - 1
                {
                    // there are no transactions to concatenate, so we just hash this one alone
                    dataToHash = currentTransactionHash
                }
                else
                {
                    // concatenate the current transaction as well as the following transaction, and hash it
                    
                    // get the following transaction
                    let followingTransactionHash = merkleTree[j + i + 1]
                    
                    // concatenate the 2 hashes
                    let dataBlock = DataBlock(rawData: currentTransactionHash)
                    dataBlock.addSegment(followingTransactionHash)
                    
                    // get the concatenated data
                    dataToHash = dataBlock.rawData
                }
                
                // hash it, add it to the end of the array
                merkleTree.append(Cryptography.doubleSha256HashData(dataToHash.bytes, length: UInt32(dataToHash.length)))
            }
            
            j += nSize;
        }
        
        // return the last element
        return merkleTree.last
    }
    
    var rawData: NSData
    {
        get
        {
            header.merkleRootHash = calculateMerkleRoot()
            return header.rawData
        }
    }
}