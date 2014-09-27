//
//  HMAC.m
//  Miner
//
//  Created by Stevie Hetelekides on 9/15/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import "Cryptography.h"

@implementation Cryptography
+ (unsigned char *)sha256HashData:(const void *)data length:(CC_LONG)length
{
    unsigned char *hash = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CC_SHA256_CTX shaContext;
    CC_SHA256_Init(&shaContext);
    CC_SHA256_Update(&shaContext, data, length);
    CC_SHA256_Final(hash, &shaContext);
    
    return hash;
}

+ (NSData *)doubleSha256HashData:(const void *)data length:(CC_LONG)length
{
    unsigned char *hash1 = [self sha256HashData:data length:length];
    unsigned char *hash2 = [self sha256HashData:hash1 length:CC_SHA256_DIGEST_LENGTH];
    return [NSData dataWithBytes:hash2 length:CC_SHA256_DIGEST_LENGTH];
}
@end
