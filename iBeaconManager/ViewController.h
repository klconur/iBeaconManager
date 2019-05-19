//
//  ViewController.h
//  NotebeAdmin
//
//  Created by Onur Kılıç on 06/08/14.
//  Copyright (c) 2014 Arbatros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBeKitClient.h"
#import "ZoomScrollView.h"
#import "POIWithRegionsList.h"

@interface ViewController : UIViewController<RequesterDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TapProtocol>
{
    NoteBeKitClient     *client;
    POIWithRegionsList  *poiWithRegions;
    NSInteger           selectedPoiRow;
    NSInteger           selectedFloorPlanRow;
}

@property(nonatomic, weak)IBOutlet ZoomScrollView   *zoomScrollView;
@property(nonatomic, weak)IBOutlet UILabel          *x;
@property(nonatomic, weak)IBOutlet UILabel          *y;
@property(nonatomic, weak)IBOutlet UITextField      *major;
@property(nonatomic, weak)IBOutlet UITextField      *minor;
@property(nonatomic, weak)IBOutlet UIPickerView     *poiPicker;
@property(nonatomic, weak)IBOutlet UIPickerView     *hallPicker;

@end
