//
//  StratumClient.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/19/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import Foundation

enum StratumMethods : String
{
    case Subscribe = "mining.subscribe"
    case Authorize = "mining.authorize"
    case Submit = "mining.submit"
}

class StratumClient : NSObject, NSStreamDelegate
{
    let TERMINATING_BYTE: UInt8 = 0x0A
    
    var delegate: StartumClientProtocol?
    var host: String
    var port: Int
    
    private var currentAwaitingRequests = Dictionary<Int, AnyObject>()
    private var inputStream:  NSInputStream?
    private var outputStream: NSOutputStream?
    
    init(host: String, port: Int)
    {
        self.host = host
        self.port = port
    }
    
    func connect()
    {
        // get streams to host/port
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        // set delegates
        inputStream?.delegate = self
        outputStream?.delegate = self
        
        // schedule run loops
        inputStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        // open streams
        inputStream?.open()
        outputStream?.open()
    }
    
    func subscribe()
    {
        // create the request, add it to the dictionary
        let request = RPCRequest(method: StratumMethods.Subscribe.toRaw())
        
        // send the request
        sendRequest(request)
    }
    
    func authorizeWorker(username: String, password: String)
    {
        // create username/password array
        let usernamePasswordArray = [username, password]
        
        // create the request
        let request = RPCRequest(method: StratumMethods.Authorize.toRaw(), params: usernamePasswordArray)
        
        // send the request
        sendRequest(request)
    }
    
    func submiteShare(miner: String, jobId: String, extraNonce2: String, nTime: String, nonce: String)
    {
        // create username/password array
        let shareInformationArray = [miner, jobId, extraNonce2, nTime, nonce]
        
        // create the request
        let request = RPCRequest(method: StratumMethods.Submit.toRaw(), params: shareInformationArray)
        
        // send the request
        sendRequest(request)
    }
    
    func close()
    {
        // close streams
        inputStream?.close()
        outputStream?.close()
        
        // remove from run loop
        inputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        // remove references to them
        inputStream = nil
        outputStream = nil
    }
    
    private func sendRequest(request: RPCRequest)
    {
        currentAwaitingRequests.updateValue(request, forKey: request.id)
        
        // get bytes of request's json data
        let dataDictonary = request.serialize()
        let data = NSJSONSerialization.dataWithJSONObject(dataDictonary, options: NSJSONWritingOptions.allZeros, error: nil)
        
        if let dataUnwrapped = data
        {
            // copy it into mutable data
            let mutableData = NSMutableData(bytes: dataUnwrapped.bytes, length: dataUnwrapped.length + 1)
            
            // add terminating byte
            var mutableBytes = UnsafeMutablePointer<UInt8>(mutableData.mutableBytes)
            mutableBytes[dataUnwrapped.length] = TERMINATING_BYTE
            
            // write the buffer
            outputStream?.write(mutableBytes, maxLength: mutableData.length)
        }
    }
    
    internal func stream(stream: NSStream, handleEvent eventCode: NSStreamEvent)
    {
        if stream is NSInputStream
        {
            switch eventCode
            {
            case NSStreamEvent.EndEncountered:
                // close the streams if needed
                close()
                
            case NSStreamEvent.HasBytesAvailable:
                // get the input stream
                let inputStream = stream as NSInputStream
                
                // read a page of data
                var buffer = NSMutableData(length: 4096)
                inputStream.read(UnsafeMutablePointer<UInt8>(buffer.mutableBytes), maxLength: 4096)

                // parse the data (into responses)
                let responses = ResponseParser.parseResponse(buffer)
                
                // handle them (fire delegate methods)
                self.handleResponses(responses)
                
                break
            default:
                println("possible stream error: \(stream.streamError)")
                break
            }
        }
    }
    
    private func handleResponses(responses: [AnyObject])
    {
        for response in responses
        {
            if let responseUnwrapped = response as? RPCResponse
            {
                if let requestUnwrapped = currentAwaitingRequests[responseUnwrapped.id] as? RPCRequest
                {
                    // remove it from awaiting requests
                    currentAwaitingRequests.removeValueForKey(responseUnwrapped.id)
                    
                    switch requestUnwrapped.method
                    {
                    case StratumMethods.Subscribe.toRaw():
                        // try and parse it as a SubscribeResult
                        if let subscribeResult = SubscribeResult.attemptParseWithResponse(responseUnwrapped)
                        {
                            delegate?.didSubscribe(subscribeResult)
                        }
                        break
                    case StratumMethods.Authorize.toRaw():
                        // get the parameters (username/password)
                        let paramsArray = requestUnwrapped.params as [String]
                        delegate?.didAuthorize(paramsArray[0], password: paramsArray[1], success: responseUnwrapped.result as Bool)
                        break
                    case StratumMethods.Submit.toRaw():
                        // get the parameters, check if we succeeded
                        let paramsArray = requestUnwrapped.params as [String]
                        let success = responseUnwrapped.error == nil && responseUnwrapped.result as Bool
                        
                        delegate?.didSubmitShare(paramsArray[1], success: success)
                        break
                    default:
                        break
                    }
                }
            }
            else if let requestUnwrapped = response as? RPCRequest
            {
                if let jobParameters = JobParameters.attemptParseWithRequest(requestUnwrapped)
                {
                    delegate?.didRecieveNewJob(jobParameters)
                }
            }
        }
    }
    
    deinit
    {
        close()
    }
}