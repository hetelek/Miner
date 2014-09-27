//
//  RPCResponse.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCResponse.h"

@implementation RPCResponse
- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.version = nil;
        self.error = nil;
        self.result = nil;
        self.id = nil;
    }
    
    return self;
}

+ (RPCResponse *)responseWithDictionary:(NSDictionary *)dictionary
{    
    RPCResponse *response = [[RPCResponse alloc] init];
    
    id error = [dictionary objectForKey:@"error"];
    response.id = [dictionary objectForKey:@"id"];
    response.version = [dictionary objectForKey:@"version"];
    
    if (![error isKindOfClass:[NSNull class]])
    {
        NSDictionary *errorDictionary;
        if ([error isKindOfClass:[NSDictionary class]])
            errorDictionary = error;
        else if ([error isKindOfClass:[NSArray class]])
        {
            NSArray *errorArray = error;
            if (errorArray.count == 3)
                errorDictionary = @{ @"code" : errorArray[0], @"message" : errorArray[1], @"data" : errorArray[2]};
            else
            {
                response.result = @NO;
                return response;
            }
        }
        
        response.error = [RPCError errorWithDictionary:errorDictionary];
    }
    else
        response.result = [dictionary objectForKey:@"result"];
    
    return response;

}

+ (RPCResponse *)responseWithError:(RPCError *)error
{
    RPCResponse *response = [[RPCResponse alloc] init];
    response.error = error;
    
    return response;
}
@end
