//
//  RPCRequest.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCRequest.h"

@implementation RPCRequest
- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.version = @"2.0";
        self.method = nil;
        self.params = @[];
        self.callback = nil;
        
        self.id = [NSNumber numberWithInt:arc4random()];
    }
    
    return self;
}

+ (RPCRequest *)requestWithMethod:(NSString *)method
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    
    return request;
}

+ (RPCRequest *)requestWithMethod:(NSString *)method params:(id)params
{
    RPCRequest *request = [self requestWithMethod:method];
    request.params = params;
    
    return request;
}

+ (RPCRequest *)requestWithMethod:(NSString *)method params:(id)params callback:(RPCRequestCallback)callback
{
    RPCRequest *request = [self requestWithMethod:method params:params];
    request.callback = callback;
    
    return request;
}

- (NSMutableDictionary *)serialize
{
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    
    if(self.version)
        [payload setObject:self.version forKey:@"jsonrpc"];
    
    if(self.method)
        [payload setObject:self.method forKey:@"method"];
    
    if(self.params)
        [payload setObject:self.params forKey:@"params"];
    
    if(self.id)
        [payload setObject:self.id forKey:@"id"];
    
    return payload;
}

+ (RPCRequest *)requestWithDictionary:(NSDictionary *)dictionary
{
    RPCRequest *request = [[RPCRequest alloc] init];
    
    request.version = dictionary[@"jsonrpc"];
    request.method = dictionary[@"method"];
    request.params = dictionary[@"params"];
    request.id = dictionary[@"id"];
    
    return request;
}
@end
