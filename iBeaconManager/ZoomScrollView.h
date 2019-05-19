//
//  ZoomScrollView.h
//  NoteBE
//
//  Created by Onur Kılıç on 27/07/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "DraggableImageView.h"

@protocol TapProtocol;

@interface ZoomScrollView : UIScrollView<UIScrollViewDelegate>
{
    DACircularProgressView  *loadingIndicator;
    DraggableImageView      *pinView;
}

@property(nonatomic, weak)id<TapProtocol> tDelegate;
@property(nonatomic) UIImageView *imageView;
@property(nonatomic) UIView      *planLocationIcon;

- (void)setImage:(NSNumber *)fileId;

@end

@protocol TapProtocol <NSObject>

- (void)onTapped:(float)x setY:(float)y;

@end