//
//  AppDelegate.swift
//  Miner
//
//  Created by Stevie Hetelekides on 9/14/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var poolMiner: PoolMiner?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /*let transactionData = NSData(hexString: "01000000062d16d640fba061f26fdf4e90c4dbfbc67f14162054eb653c0ac7db2a722aa876010000008b48304502207ab1d375a81ba18e8807d8d3cfff1adad9e7518ab21f79ed2e9b4a93e0a94d42022100fc7fe3dcb5d7000706cf4f4325570693cad965dd3cd96b189e7641e004f86532014104e21d2f1378d9c9c469881cb44fb5c754321f5755be121f435508d92c8a85e9c7915eeccd3084d9294830a9a9ef616261d942426e9658a16a8b8ffd1c1d0495fdffffffff42d93f847b35e51038ee34b789c34bcff8e4c590e52f3f0b6e8d6fe180deee07010000008a47304402204b0a5efd5da652bd1636afcfcbe8fc0d7aed4bd51d8b766553270647fd6766ae02207cfb876d45aac989c6745001cd5e6c24b1914b6855ae70a3d9579b85c255ae94014104b013a968505bdc85782cd84bec1ed491dd10a3ba6c34144acce3e9c61ecf5a799ee19558d0bd9dcb80ea737b7f9e283ce10c76b19a5d3ef1a40b00a3e358e374ffffffffcccdb0a551ce5449105c18217fb74addc8bd785da9c4c1c584c2305666580301000000008c493046022100bd84bc54749d3be7313f79d37d072d4f0b9e23da7a19a4f496932ea8bab44798022100e4a0532c18b2159720e719c82d705cf1ab0fadc6e439302a1804d513cede340b014104fd03e8d622e52d5299a824a9854f5e41caf1888301fabbc277d0e99f60174accc2c5f0b8552ae3258a3077c3a6897750820edb62b1cd692e40fc1698c4e0ab27ffffffffbabcbe0a13bd2a1c5c8dbc4eb26deff966272120e21eca2c60580a67675ee823000000008a47304402201844792fc81e584b664ad87c2c6c5c3681963cbaf4d84a638334f5ad9d9203cb022004b79b739444d5710dd43e46735e74a57e27c80f0c718b8bc50b0b3b18cbab9401410464604294fdccd3003033d4f36f847a6dae26fcd83d132aaedca6f7c6ef22bad91a0a7a215a53491bf01fb5ba565fd90b75ab3b03effbe07b4e54201ecb946c45ffffffff08a7e5bb52de0c4ccdef28f5b0bf5e088b57975ae1594666d0dd7c8e47c8a585010000008b483045022100bb8fa50411cab0c0deb4e89b6736e5d91a0a8310fa98123bdfde1315b5a39f7002206ffdc6679decdda2393cb84023ffb96184178bd7cb2e113b1d737f61102094620141048313befc25acbc7e912e1d96dc04039bcf6cdb5959f6e3371b4dc78d76634b6212dfa89c01bf3dd0f7cc593fc126a40ad99d3ba15d0cc61a6d32b26cfe9f7ef4ffffffff610472e56d3a392cab79385a233f4e063a567a9848ff668becf19aa2a9fa5587000000008b483045022100e35f7e9c1c3d11065fdcc75d77e9b55077bdfcf114bf7479f219989269cac186022047a24f19226b46a1b68b49a847d67546335c1c25cc15507b11edf8eaf01541c601410413704d54180f498439e70a8564a0b3c2ad55158ed49a11dde7bf135948aea30985bec3aa60f4eaa694af125e7de37c1d83ed0a2fcbbd450d75f7b99d7bff3b20ffffffff026c211600000000001976a914098bd1625a4eb1b06ff43cd637bd180458b0e5b188ac30d39700000000001976a914e828ce88acb2df5179a509f049c3e0245fb502e888ac00000000")
        let trans = Transaction(rawData: transactionData)
        
        let rawData = trans.rawData
        let hash = Cryptography.doubleSha256HashData(rawData.bytes, length: UInt32(rawData.length)).reverse()
        println("hash: \(hash)")*/
        
        self.poolMiner = PoolMiner(host: "stratum.bitcoin.cz", port: 3333)
        
        var blockData = NSData(hexString: "F9BEB4D9ABCDEF020100000000000000000000000000000000000000000000000000000000000000000000003BA3EDFD7A7B12B27AC72C3E67768F617FC81BC3888A51323A9FB8AA4B1E5E4A29AB5F49FFFF001D1DAC2B7C0101000000010000000000000000000000000000000000000000000000000000000000000000FFFFFFFF4D04FFFF001D0104455468652054696D65732030332F4A616E2F32303039204368616E63656C6C6F72206F6E206272696E6B206F66207365636F6E64206261696C6F757420666F722062616E6B73FFFFFFFF0100F2052A01000000434104678AFDB0FE5548271967F1A67130B7105CD6A828E03909A67962E0EA1F61DEB649F6BC3F4CEF38C4F35504E51EC112DE5C384DF7BA0B8D578A4C702B6BF11D5FAC00000000")
        let block = Block(rawData: blockData)
        
        let rawBlockHeaderData = block.rawData
        let hash = Cryptography.doubleSha256HashData(rawBlockHeaderData.bytes, length: UInt32(rawBlockHeaderData.length)).reverse()!
        println(hash)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

