//
//  NSDate+Util.h
//  iBeaconManager
//
//  Created by Onur Kılıç on 21/04/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(JsonDateCategory)

- (NSDate *) getJSONDate;
+ (NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;
+ (NSString*)urlEscapeString:(NSString *)unencodedString;

@end
