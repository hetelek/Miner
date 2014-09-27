//
//  RPCError.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Reserved rpc errors
typedef enum {
    RPCParseError = -32700,
    RPCInvalidRequest = -32600,
    RPCMethodNotFound = -32601,
    RPCInvalidParams = -32602,
    RPCInternalError = -32603,
    RPCServerError = 32000,
    RPCNetworkError = 32001,
    RPCUnknown = 20,
    RPCJobNotFound = 21,
    RPCDuplicateShare = 22,
    RPCLowDifficultyShare = 23,
    RPCUnauthorizedWorker = 24,
    RPCNotSubscribed = 25
} RPCErrorCode;

/**
 * RPCError.
 * 
 * Simple object containing information about errors. Erros can be generated serverside or internally within this client.
 * See RPCErrorCode above for the most common errors.
 */
@interface RPCError : NSObject

#pragma mark - Properties -

/**
 * RPC Error code. Error code that you can match against the RPCErrorCode enum above. 
 * 
 * Server can generate other errors aswell, for a description of server errors you need to contact server
 * administrator ;-)
 *
 * @param RPCErrorCode
 */
@property (readonly) RPCErrorCode code;

/**
 * RPC Error message
 * 
 * A more detailed message describing the error. 
 *
 * @param NSString
 */
@property (readonly, retain) NSString *message;

/**
 * Some random data
 * 
 * If the server supports sending debug data when server errors accours, it will be stored here
 *
 * @param id
 */
@property (readonly, retain) id data;

#pragma mark - Methods

// These methods is self explaining.. right?
- (id) initWithCode:(RPCErrorCode) code;
- (id) initWithCode:(RPCErrorCode) code message:(NSString*) message data:(id)data;
+ (id) errorWithCode:(RPCErrorCode) code;
+ (id) errorWithDictionary:(NSDictionary*) error;

@end
