//
//  ZoomScrollView.m
//  NoteBE
//
//  Created by Onur Kılıç on 27/07/14.
//  Copyright (c) 2014 NoteBE. All rights reserved.
//

#import "ZoomScrollView.h"
#import "UIImageView+Util.h"
#import "MWCommon.h"

@implementation ZoomScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupView];
        [self setupLoadingIndicator];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor blackColor];
    self.delegate = self;
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    [self addTapGestureRecognizer];
    self.planLocationIcon = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     40,
                                                                     40)];
    [self.planLocationIcon setBackgroundColor:[UIColor colorWithRed:128/255 green:0 blue:1 alpha:.8]];
    self.planLocationIcon.layer.cornerRadius = 20;
    [self.planLocationIcon setHidden:YES];
    [self.imageView addSubview:self.planLocationIcon];
    
    CABasicAnimation *scaleAnimation    = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration             = 1.5;
    scaleAnimation.repeatCount          = HUGE_VAL;
    scaleAnimation.autoreverses         = YES;
    scaleAnimation.fromValue            = [NSNumber numberWithFloat:.8];
    scaleAnimation.toValue              = [NSNumber numberWithFloat:1.4];
    [self.planLocationIcon.layer addAnimation:scaleAnimation forKey:@"scale"];
}

- (void)addPin
{
    pinView = [[DraggableImageView alloc] initWithImage:[UIImage imageNamed:@"map-pin-red-hi"]];
    pinView.layer.anchorPoint = CGPointMake(0.5, 1);
    [pinView setUserInteractionEnabled:YES];
    [self.imageView addSubview:pinView];
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTaps:)];
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
}

- (void) handleTaps:(UITapGestureRecognizer*)paramSender
{
    NSUInteger touchCounter = 0;
    for (touchCounter = 0; touchCounter < paramSender.numberOfTouchesRequired; touchCounter++)
    {
        CGPoint touchPoint = [paramSender locationOfTouch:touchCounter inView:paramSender.view];
        if (pinView == nil)
        {
            [self addPin];
        }
        pinView.center = touchPoint;
        [self.tDelegate onTapped:touchPoint.x setY:touchPoint.y];
        NSLog(@"Touch #%lu: %@", (unsigned long)touchCounter+1, NSStringFromCGPoint(touchPoint));
    }
}

- (void)setupLoadingIndicator
{
    // Loading indicator
    loadingIndicator = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 30.0f, 40.0f, 40.0f)];
    loadingIndicator.userInteractionEnabled = NO;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        loadingIndicator.thicknessRatio = 0.1;
        loadingIndicator.roundedCorners = NO;
    } else {
        loadingIndicator.thicknessRatio = 0.2;
        loadingIndicator.roundedCorners = YES;
    }
    loadingIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:loadingIndicator];
    
    // Listen progress notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setProgressFromNotification:)
                                                 name:PROGRESS_NOTIFICATION
                                               object:nil];
}

- (void)hideLoadingIndicator
{
    loadingIndicator.hidden = YES;
}

- (void)showLoadingIndicator
{
    loadingIndicator.progress = 0;
    loadingIndicator.hidden = NO;
}

- (void)layoutSubviews
{
	// Position indicators (centre does not seem to work!)
	if (!loadingIndicator.hidden)
        loadingIndicator.frame = CGRectMake(floorf((self.bounds.size.width - loadingIndicator.frame.size.width) / 2.),
                                            floorf((self.bounds.size.height - loadingIndicator.frame.size.height) / 2),
                                            loadingIndicator.frame.size.width,
                                            loadingIndicator.frame.size.height);
}

- (void)setProgressFromNotification:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];
    float progress = [[dict valueForKey:@"progress"] floatValue];
    loadingIndicator.progress = MAX(MIN(1, progress), 0);
}

- (void)setImage:(NSNumber *)fileId
{
    [self showLoadingIndicator];
    [self.imageView setImage:nil];
    __weak typeof(self) weakSelf = self;
    [self.imageView setImageWithFileId:fileId setVersion:@"" completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image != nil)
        {
            [weakSelf setContent:image];
            [weakSelf hideLoadingIndicator];
        }
    }];
}

- (void)setContent:(UIImage *)image
{
    self.minimumZoomScale = 1.;
    [self setZoomScale:1.];
    if (image.size.width > CGRectGetWidth(self.frame))
    {
        self.minimumZoomScale = CGRectGetWidth(self.frame) / image.size.width;
    }
    //    [self.imageView setImage:image];
    [self.imageView setFrame:CGRectMake(0,
                                        0,
                                        image.size.width,
                                        image.size.height)];
    self.contentSize = image.size;
    self.maximumZoomScale = 1.1;
    [self setZoomScale:self.minimumZoomScale];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andUIView:(UIView *)rView
{
    CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = rView.frame;
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
    {
        frameToCenter.origin.x = (boundsSize.width-frameToCenter.size.width) / 2;
    }
    else
    {
        frameToCenter.origin.x = 0;
    }
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
    {
        frameToCenter.origin.y = (boundsSize.height-frameToCenter.size.height) / 2;
    }
    else
    {
        frameToCenter.origin.y = 0;
    }
    return frameToCenter;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageView.frame = [self centeredFrameForScrollView:scrollView andUIView:self.imageView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
