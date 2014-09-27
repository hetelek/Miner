//
//  JobParameters.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/20/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

class JobParameters
{
    var jobId: String!
    var previousHash: String!
    var coinb1: String!
    var coinb2: String!
    var merkleBranch: [String] = []
    var version: String!
    var nbits: String!
    var ntime: String!
    var cleanJobs: Bool!

    class func attemptParseWithRequest(response: RPCRequest) -> JobParameters?
    {
        if let paramsArray = response.params as? [AnyObject]
        {
            if paramsArray.count != 9
            {
                return nil
            }
            
            let jobParameters = JobParameters()
            
            // parse array into job parameters
            jobParameters.jobId = paramsArray[0] as String
            jobParameters.previousHash = paramsArray[1] as String
            jobParameters.coinb1 = paramsArray[2] as String
            jobParameters.coinb2 = paramsArray[3] as String
            jobParameters.merkleBranch = paramsArray[4] as [String]
            jobParameters.version = paramsArray[5] as String
            jobParameters.nbits = paramsArray[6] as String
            jobParameters.ntime = paramsArray[7] as String
            jobParameters.cleanJobs = paramsArray[8] as Bool
            
            return jobParameters
        }
        
        return nil
    }
}