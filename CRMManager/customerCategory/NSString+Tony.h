//
//  NSString+Tony.h
//  WX189study
//
//  Created by Tony zhou on 13-5-10.
//  Copyright (c) 2013年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface NSString (Tony) <NSXMLParserDelegate> 

+ (NSString *)md5StringFromString:(NSString *)s;
+ (NSString *)md5:(NSString *)value;
+ (NSString *)stringOfAddPercentEscapesWithString:(NSString *)s;

+ (NSString *)base64StringFromData:(NSData *)data;
//+ (NSData *) base64DataFromString:(NSString *)string;

@end
