//
//  UIImageView+Util.h
//  NoteBE
//
//  Created by Onur Kılıç on 23/05/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDWebImage/UIImageView+WebCache.h"

#define PROGRESS_NOTIFICATION   @"progress_notification"

@interface UIImageView(CacheCategory)

- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version;
- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version completed:(void ( ^ )(UIImage *image, NSError *error, SDImageCacheType cacheType))predicate;
- (void)setImageWithFileId:(NSNumber *)fileId setVersion:(NSString *)version setPlaceholderImage:(UIImage *)placeholderImage;

@end
