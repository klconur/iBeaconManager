//
//  DraggableImageView.m
//  iBeaconManager
//
//  Created by Onur Kılıç on 06/08/14.
//  Copyright (c) 2014 Arbatros. All rights reserved.
//

#import "DraggableImageView.h"

@implementation DraggableImageView

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Retrieve the touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    startLocation = pt;
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    // Move relative to the original touch point
    CGPoint pt = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    frame.origin.x += pt.x - startLocation.x;
    frame.origin.y += pt.y - startLocation.y;
    [self setFrame:frame];
}

@end
