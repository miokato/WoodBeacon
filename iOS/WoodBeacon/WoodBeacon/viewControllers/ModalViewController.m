//
//  ModalViewController.m
//  WoodBeacon
//
//  Created by 加藤 未央 on 2/12/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

// おはよう

#import "ModalViewController.h"
#import <CoreLocation/CoreLocation.h>

// Define UUID and AuthorID
#define kProximityUUID  @"00000000-3011-1001-b000-001c4d50762e"
#define kIdentifier     @"fablabkamakura_beacon"

#define blackBeacon_Major 1
#define blackBeacon_Minor 0

#define whiteBeacon_Major 1
#define whiteBeacon_Minor 4

@interface ModalViewController ()

// Make four label can be received from BLE112 peripheral
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;



// Make property of CLLocationManager, NSUUID and CLBeaconRegion
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUUID *proximityUUID;
@property (nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation ModalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Method of that reset all labels
    [self resetLabels];
    
    self.beaconRegion.notifyEntryStateOnDisplay = TRUE;
    
    // Start region monitoring
    [self startRegionMonitoring];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Beacon


- (void)startRegionMonitoring {
    
    // if enable monitoring
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        // initialize location manager property
        self.locationManager = [[CLLocationManager alloc] init];
        
        // set delegate location manager to self
        self.locationManager.delegate = self;
        
        // set UUID
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kProximityUUID];
        
        // set UUID and ID tobeacon region
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                    major:whiteBeacon_Major
                                                                    minor:whiteBeacon_Minor
                                                               identifier:kIdentifier];
        
        // start monitoring
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
    }
}

// reset labels
- (void)resetLabels {
    
    self.statusLabel.text = @"No Beacons";
    
    self.proximityLabel.text = nil;
    self.rssiLabel.text = nil;
    self.accuracyLabel.text = nil;
}



// After monitoring region
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Start monitoring for region");
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

// Show when location manager coldn't monitering region
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSLog(@"Failed monitoring with error:%@", error);
}

// Show error log when location manager failed monitoring
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError:%@", error);
}

// After you have already moniter the region
- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
        {
            // start ranging
            if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
                
                // Start ranging in beacon region
                [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
            }
            self.statusLabel.text = @"Beacon in range:";
            break;
        }
        case CLRegionStateOutside:
        {
            self.statusLabel.text = @"Go out Region";
            self.view.backgroundColor = [UIColor darkGrayColor];
        }
        case CLRegionStateUnknown:
        default:
            break;
    }
}

// Be called when you enterd the region
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    
    self.statusLabel.text = @"Beacon in range:";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable])
    {
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

// Be called when you exit the region
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    [self resetLabels];
    
    // stop ranging
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}


- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    CLBeacon *beacon = beacons.firstObject;
    
    NSString *proximityStr;
    
    switch (beacon.proximity) {
            
        case CLProximityImmediate:
        {
            proximityStr = @"Immediate!!";
            self.view.backgroundColor = [UIColor redColor];
            break;
        }
        case CLProximityNear:
        {
            proximityStr = @"Near";
            self.view.backgroundColor = [UIColor yellowColor];
            break;
        }
        case CLProximityFar:
        {
            proximityStr = @"Far";
            self.view.backgroundColor = [UIColor greenColor];
            break;
        }
        default:
        {
            proximityStr = @"Nothing!";
//            self.view.backgroundColor = [UIColor blackColor];
            break;
        }
    }
    
    self.proximityLabel.text = proximityStr;
    self.rssiLabel.text = [NSString stringWithFormat:@"%ld [dB]", (long)beacon.rssi];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%.0f [m]", beacon.accuracy];
}


@end
