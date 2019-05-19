//
//  NSDate+Util.m
//  iBeaconManager
//
//  Created by Onur Kılıç on 21/04/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString(JsonDateCategory)

- (NSDate *) getJSONDate
{
    NSString* header = @"/Date(";
    NSUInteger headerLength = [header length];
    
    NSString*  timestampString;
    
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    [scanner setScanLocation:headerLength];
    [scanner scanUpToString:@")" intoString:&timestampString];
    
    NSCharacterSet* timezoneDelimiter = [NSCharacterSet characterSetWithCharactersInString:@"+-"];
    NSRange rangeOfTimezoneSymbol = [timestampString rangeOfCharacterFromSet:timezoneDelimiter];
    
    if (rangeOfTimezoneSymbol.length!=0)
    {
        scanner = [[NSScanner alloc] initWithString:timestampString];
        
        NSRange rangeOfFirstNumber;
        rangeOfFirstNumber.location = 0;
        rangeOfFirstNumber.length = rangeOfTimezoneSymbol.location;
        
        NSRange rangeOfSecondNumber;
        rangeOfSecondNumber.location = rangeOfTimezoneSymbol.location + 1;
        rangeOfSecondNumber.length = [timestampString length] - rangeOfSecondNumber.location;
        
        NSString* firstNumberString = [timestampString substringWithRange:rangeOfFirstNumber];
        //        NSString* secondNumberString = [timestampString substringWithRange:rangeOfSecondNumber];
        
        unsigned long long firstNumber = [firstNumberString longLongValue];
        //        NSUInteger secondNumber = [secondNumberString intValue];
        
        NSTimeInterval interval = firstNumber/1000;
        
        return [NSDate dateWithTimeIntervalSince1970:interval];
    }
    
    unsigned long long firstNumber = [timestampString longLongValue];
    NSTimeInterval interval = firstNumber/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

+ (NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary
{
    //    NSMutableString *urlWithQuerystring = [[NSMutableString alloc] initWithString:urlString];
    
    for (id key in dictionary)
    {
        NSString *keyString = [key description];
        NSString *valueString = [[dictionary objectForKey:key] description];
        //        if ([urlWithQuerystring rangeOfString:@"?"].location == NSNotFound)
        //        {
        NSString *formattedKey  = [NSString stringWithFormat:@"(%@:)", keyString];
        NSString *value         = [self urlEscapeString:valueString];
        urlString = [urlString stringByReplacingOccurrencesOfString:formattedKey
                                                         withString:value];
        //        [urlWithQuerystring appendFormat:@"%@/", [self urlEscapeString:valueString]];
        //        }
        //        else
        //        {
        //            [urlWithQuerystring appendFormat:@"&%@=%@", [self urlEscapeString:keyString], [self urlEscapeString:valueString]];
        //        }
    }
    return urlString;
}

+ (NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

@end
