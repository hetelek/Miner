//
//  HMAC.h
//  Miner
//
//  Created by Stevie Hetelekides on 9/15/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface Cryptography : NSObject

+ (unsigned char *)sha256HashData:(const void *)data length:(CC_LONG)length;
+ (NSData *)doubleSha256HashData:(const void *)data length:(CC_LONG)length;

@end
