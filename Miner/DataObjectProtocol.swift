

//
//  DataObject.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/16/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

protocol DataObjectProtocol
{
    init(rawData: NSData)
    var rawData: NSData { get }
}