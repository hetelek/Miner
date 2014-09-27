//
//  StratumClientProtocol.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/20/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

protocol StartumClientProtocol
{
    func didRecieveNewJob(job: JobParameters)
    func didSubscribe(result: SubscribeResult)
    func didAuthorize(username: String, password: String, success: Bool)
    func didSubmitShare(jobId: String, success: Bool)
}