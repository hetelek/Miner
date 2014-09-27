//
//  RPCError.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCError.h"

@interface RPCError ()
@property (readwrite) RPCErrorCode code;
@property (readwrite, retain) NSString *message;
@property (readwrite, retain) id data;
@end

@implementation RPCError
- (id)initWithCode:(RPCErrorCode)code message:(NSString *)message data:(id)data
{
    self = [super init];
    
    if(self)
    {
        self.code = code;
        self.message = message;
        self.data = data;
    }
    
    return self;
}

- (id)initWithCode:(RPCErrorCode)code
{
    NSString *message;
    
    switch (code) {
        case RPCParseError:
            message = @"Parse error";
            break;
        
        case RPCInternalError:
            message = @"Internal error";
            break;
            
        case RPCInvalidParams:
            message = @"Invalid params";
            break;
    
        case RPCInvalidRequest:
            message = @"Invalid Request";
            break;
        
        case RPCMethodNotFound:
            message = @"Method not found";
            break;
            
        case RPCNetworkError:
            message = @"Network error";
            break;
            
        case RPCUnknown:
            message = @"Unkown/other error";
            break;
            
        case RPCJobNotFound:
            message = @"Job not found";
            break;
            
        case RPCDuplicateShare:
            message = @"Duplicate share";
            break;
            
        case RPCLowDifficultyShare:
            message = @"Low difficulty share";
            break;
            
        case RPCUnauthorizedWorker:
            message = @"Unauthorized worker";
            break;
            
        case RPCNotSubscribed:
            message = @"Not subscribed";
            break;
            
        case RPCServerError:
        default:
            message = @"Server error";
            break;
    }
    
    return [self initWithCode:code message:message data:nil];
}

+ (id)errorWithCode:(RPCErrorCode)code
{
    return [[RPCError alloc] initWithCode:code];
}

+ (id)errorWithDictionary:(NSDictionary *)error
{
    return [[RPCError alloc] initWithCode:[[error objectForKey:@"code"] intValue]
                                   message:[error objectForKey:@"message"]
                                      data:[error objectForKey:@"data"]];
}

- (NSString *)description
{
    if(self.data != nil)
        return [NSString stringWithFormat:@"RPCError: %@ (%i): %@.", self.message, self.code, self.data];
    else
        return [NSString stringWithFormat:@"RPCError: %@ (%i).", self.message, self.code];
}
@end
