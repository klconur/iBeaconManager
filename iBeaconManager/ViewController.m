//
//  ViewController.m
//  NotebeAdmin
//
//  Created by Onur Kılıç on 06/08/14.
//  Copyright (c) 2014 Arbatros. All rights reserved.
//

#import "ViewController.h"
#import "SVProgressHUD.h"

#define GETREQUEST [NSNumber numberWithInt:0]
#define SETREQUEST [NSNumber numberWithInt:1]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestData];
    [self.zoomScrollView setTDelegate:self];
    [self.zoomScrollView setHidden:YES];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

- (void)requestData
{
    client = [[NoteBeKitClient alloc] init];
    client.delegate = self;
    [client requestPoisWithRegions:GETREQUEST];
}

- (void)onTapped:(float)x setY:(float)y
{
    [self.x setText:[NSString stringWithFormat:@"%.f", x]];
    [self.y setText:[NSString stringWithFormat:@"%.f", y]];
}

- (IBAction)onSaveClicked:(id)sender
{
    [SVProgressHUD show];
    InstallationRegion *region = [[[poiWithRegions.Result objectAtIndex:selectedPoiRow] regions] objectAtIndex:selectedFloorPlanRow];
    NSNumber *floorPlanId = [NSNumber numberWithInt:0];
    if ([region.poiFloorPlans count] > 0)
    {
        floorPlanId = [[region.poiFloorPlans objectAtIndex:0] Id];
    }
    [client setLocationOfBeaconFloorPlan:self.major.text setMinor:self.minor.text setX:self.x.text setY:self.y.text setFloorPlanId:floorPlanId setRegionId:region.Id setState:SETREQUEST];
}

- (void)showFloorPlan:(NSInteger)row
{
    selectedFloorPlanRow = row;
    NSMutableArray *floorPlans = [[[[poiWithRegions.Result objectAtIndex:selectedPoiRow] regions] objectAtIndex:row] poiFloorPlans];
    if ([floorPlans count] > 0)
    {
        [self.zoomScrollView setHidden:NO];
        [self.zoomScrollView setImage:[[floorPlans objectAtIndex:0] floorPlanFileId]];
    }
}

- (void)clearControls
{
    
}

#pragma mark
#pragma UIPickerView
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.zoomScrollView setHidden:YES];
    if ([pickerView isEqual:self.poiPicker])
    {
        selectedPoiRow = row;
        [self.hallPicker reloadAllComponents];
        [self showFloorPlan:0];
    }
    else
    {
        [self showFloorPlan:row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.poiPicker])
    {
        return [[poiWithRegions.Result objectAtIndex:row] name];
    }
    else
    {
        return [[[[poiWithRegions.Result objectAtIndex:selectedPoiRow] regions] objectAtIndex:row] name];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView isEqual:self.poiPicker])
    {
        return [poiWithRegions.Result count];
    }
    else
    {
        return [[[poiWithRegions.Result objectAtIndex:selectedPoiRow] regions] count];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma mark
#pragma RequesterDelegate
- (void)onSuccess:(id)responseObject State:(id)state
{
    if ([state intValue] == [GETREQUEST intValue])
    {
        poiWithRegions = [POIWithRegionsList objectWithDictionary:responseObject];
        [self.poiPicker reloadAllComponents];
        [self.hallPicker reloadAllComponents];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"Great Success!"];
    }
}

- (void)onFailed:(NSError *)error State:(id)state
{
    [SVProgressHUD showErrorWithStatus:@"Failed with Error"];
}

@end
