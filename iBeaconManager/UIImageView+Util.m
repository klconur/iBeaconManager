//
//  UIImageView+Util.m
//  NoteBE
//
//  Created by Onur Kılıç on 23/05/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import "UIImageView+Util.h"
#import "NSString+Util.h"
#import "ProgramData.h"

#define TIMEOUT                 120

@implementation UIImageView(CacheCategory)

- (NSDictionary *)getParameters:(NSNumber *)logoId setVersion:(NSString *)version
{
    NSArray      *keys       = [NSArray arrayWithObjects:KEY_ID, nil];
    NSArray      *objects    = [NSArray arrayWithObjects:logoId, nil];
    return [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}

- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version setPlaceholderImage:(UIImage *)placeholderImage
{
    NSDictionary *parameters = [self getParameters:fileId setVersion:version];
    NSString     *urlString  = [NSString addQueryStringToUrlString:GETIMAGEURL withDictionary:parameters];
    NSURL        *url        = [NSURL URLWithString:urlString];
    [self addHeaders];
    [self setImageWithURL:url placeholderImage:placeholderImage];
}

- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version
{
    NSDictionary *parameters = [self getParameters:fileId setVersion:version];
    NSString     *urlString  = [NSString addQueryStringToUrlString:GETIMAGEURL withDictionary:parameters];
    NSURL        *url        = [NSURL URLWithString:urlString];
    [self addHeaders];
    [self setImageWithURL:url];
}

- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version completed:(void ( ^ )(UIImage *image, NSError *error, SDImageCacheType cacheType))predicate
{
    NSDictionary *parameters = [self getParameters:fileId setVersion:version];
    NSString     *urlString  = [NSString addQueryStringToUrlString:GETIMAGEURL withDictionary:parameters];
    NSURL        *url        = [NSURL URLWithString:urlString];
    [self addHeaders];
    [self setImageWithURL:url completed:predicate];
    [self setImageWithURL:url placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize > 0)
        {
            float progress = receivedSize / (float)expectedSize;
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:progress], @"progress", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:PROGRESS_NOTIFICATION object:dict];
        }
    } completed:predicate];
}

- (void)addHeaders
{
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    NSString *authorization = [NSString stringWithFormat:@"Mobile 1:%@", [ProgramData getDeviceToken]];
    [manager setMaxConcurrentDownloads:20];
    [manager setDownloadTimeout:TIMEOUT];
    [manager setValue:authorization forHTTPHeaderField:@"Authorization"];
    [manager setValue:[ProgramData getDeviceLocale] forHTTPHeaderField:@"Accept-Language"];
}

@end
