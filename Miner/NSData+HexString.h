//
//  NSData+HexString.h
//  Miner
//
//  Created by Stevie Hetelekides on 9/16/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexString)

+ (NSData *)dataWithHexString:(NSString *)hex;
- (NSData *)reverse;
- (NSData *)reverseInChunks:(NSUInteger)chunkSize;

@end
