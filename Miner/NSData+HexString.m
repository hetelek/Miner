//
//  NSData+HexString.m
//  Miner
//
//  Created by Stevie Hetelekides on 9/16/14.
//  Copyright (c) 2014 Expetelek. All rights reserved.
//

#import "NSData+HexString.h"

@implementation NSData (HexString)
+ (NSData *)dataWithHexString:(NSString *)hex
{
    char buf[3];
    buf[2] = '\0';
    
    NSUInteger halfedStringSize = [hex length] / 2;
    unsigned char *bytes = malloc(halfedStringSize);
    unsigned char *bp = bytes;
    for (CFIndex i = 0; i < [hex length]; i += 2)
    {
        buf[0] = [hex characterAtIndex:i];
        buf[1] = [hex characterAtIndex:i + 1];
        
        char *b2 = NULL;
        *bp++ = strtol(buf, &b2, 16);
    }
    
    return [NSData dataWithBytesNoCopy:bytes length:halfedStringSize freeWhenDone:YES];
}

- (NSData *)reverse
{
    return [self reverseInChunks:self.length];
}

- (NSData *)reverseInChunks:(NSUInteger)chunkSize
{
    const char *bytes = [self bytes];
    char *reverseBytes = malloc(sizeof(char) * [self length]);
    
    for (int x = 0; x < self.length; x += chunkSize)
        for (int i = 1; i <= chunkSize; i++)
            reverseBytes[x + chunkSize - i] = bytes[x + i - 1];
    
    NSData *reversedData = [NSData dataWithBytes:reverseBytes length:[self length]];
    free(reverseBytes);
    
    return reversedData;
}
@end