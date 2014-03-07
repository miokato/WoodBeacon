//
//  StartViewController.m
//  WoodBeaconGuest
//
//  Created by 加藤 未央 on 2/20/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

// header
#import "StartViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

// header of views
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

// id
#define kIdentifier     @"com.bunasan.mio.bunasan"

// Beacon major and minors
#define blackBeaconMajor 1
#define blackBeaconMinor 0
#define whiteBeaconMajor 1
#define whiteBeaconMinor 1
#define redBeaconMajor 1
#define redBeaconMinor 2

@interface StartViewController ()<CLLocationManagerDelegate>

// ビーコンリージョンがimmediateになったときに立つフラグ
@property (nonatomic) BOOL isShowingFirstView;

// Make property of CLLocationManager, NSUUID and CLBeaconRegion
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUUID *proximityUUID;

// make two beacon regions
@property (nonatomic) CLBeaconRegion *beaconRegion;

@end

@implementation StartViewController

#pragma mark view

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // リージョンのモニタリングをスタート
    [self startRegionMonitoring];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action

// exitによる画面遷移のためのメソッド
- (IBAction)returnStartViewForSegue:(UIStoryboardSegue *)segue
{
    self.isShowingFirstView = NO;
}

// major,minorIDでビーコンを識別して、それぞれ別の画面へ遷移する
- (void)detectWhichBeacons:(int)major withMinor:(int)minor
{
     // 作成したフラグ[isShowingFirstView]がNOのときのみ、モーダルビューを表示
    if (self.isShowingFirstView == NO) {
        
        // majorが1かつminorが0のビーコンの情報を表示
        if ((major == blackBeaconMajor) && (minor == blackBeaconMinor)) {
            
            // ここでフラグをYESに設定する。(1度ビューが開かれたら、2度目は一度閉じるまで開かない)
            self.isShowingFirstView = YES;
            
            NSString *majorString = [NSString stringWithFormat:@"%d",major];
            NSString *minorString = [NSString stringWithFormat:@"%d",minor];
            
            // major,minorでデータを照合して、parseから正しいデータを取得する。
            PFQuery *query = [PFQuery queryWithClassName:@"Beacons"];
            
            [query whereKey:@"Major" equalTo:majorString];  // Majorが1のデータにしぼる
            [query whereKey:@"Minor" equalTo:minorString];  // Minorが0のデータにしぼる
            [query orderByDescending:@"createdAt"];         // 日付の新しい順にソート
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {

                if (!error) {
                
                    // 画面遷移の際に値を受け渡すときは、遷移先で値を渡すプロパティを用意し、遷移元で遷移先のインスタンスをつくって値をわたす。
                    FirstViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"firstView"];
                    
                    [self presentViewController:firstViewController animated:YES completion:^(){
                        // completionの部分にブロックを作ることで、画面遷移時に次のビューへ漏れなく値を代入することができる。
                        firstViewController.titleView.text = object[@"Title"];
                        firstViewController.descriptionView.text = object[@"Desctiption"];
                    }];
                                        
                } else {
                    // フラグをNOにする。
                    self.isShowingFirstView = NO;
                    NSLog(@"Error : %@ %@", error, [error userInfo]);
                }
            }];
        }
        // majorが1かつminorが4のビーコンの情報を表示
        else if ((major == whiteBeaconMajor) && (minor == whiteBeaconMinor)) {
            
            // ここでフラグをYESに設定する。(1度ビューが開かれたら、2度目は一度閉じるまで開かない)
            self.isShowingFirstView = YES;
            
            // major,minorでデータを照合して、parseから正しいデータを取得する。
            PFQuery *query = [PFQuery queryWithClassName:@"Beacons"];
            [query whereKey:@"Major" equalTo:@"1"]; // Majorが1のデータにしぼる
            [query whereKey:@"Minor" equalTo:@"1"]; // Minorが1のデータにしぼる
            [query orderByDescending:@"createdAt"]; // 日付の新しい順にソート
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    // 画面遷移の際に値を受け渡すときは、遷移先で値を渡すプロパティを用意し、遷移元で遷移先のインスタンスをつくって値をわたす。
                    SecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondView"];
                    
                    [self presentViewController:secondViewController animated:YES completion:^(){
                        // completionの部分にブロックを作ることで、画面遷移時に次のビューへ漏れなく値を代入することができる。
                        secondViewController.titleView.text = object[@"Title"];
                        secondViewController.descriptionView.text = object[@"Desctiption"];
                    }];
                    
                } else {
                    // フラグをNOにする。
                    self.isShowingFirstView = NO;
                    NSLog(@"Error : %@ %@", error, [error userInfo]);
                }
            }];
        }
        // majorが1かつminorが4のビーコンの情報を表示
        else if ((major == redBeaconMajor) && (minor == redBeaconMinor)) {
            
            // ここでフラグをYESに設定する。(1度ビューが開かれたら、2度目は一度閉じるまで開かない)
            self.isShowingFirstView = YES;
            
            // major,minorでデータを照合して、parseから正しいデータを取得する。
            PFQuery *query = [PFQuery queryWithClassName:@"Beacons"];
            [query whereKey:@"Major" equalTo:@"1"]; // Majorが1のデータにしぼる
            [query whereKey:@"Minor" equalTo:@"2"]; // Minorが1のデータにしぼる
            [query orderByDescending:@"createdAt"]; // 日付の新しい順にソート
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    // 画面遷移の際に値を受け渡すときは、遷移先で値を渡すプロパティを用意し、遷移元で遷移先のインスタンスをつくって値をわたす。
                     ThirdViewController *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdView"];
                    
                    [self presentViewController:thirdViewController animated:YES completion:^(){
                        // completionの部分にブロックを作ることで、画面遷移時に次のビューへ漏れなく値を代入することができる。
                        thirdViewController.titleLabel.text = object[@"Title"];
                        thirdViewController.descriptionView.text = object[@"Desctiption"];
                    }];
                    
                } else {
                    // フラグをNOにする。
                    self.isShowingFirstView = NO;
                    NSLog(@"Error : %@ %@", error, [error userInfo]);
                }
            }];
        }
    }
}

#pragma mark - Beacon

// ビーコンのリージョンをモニタリング開始
- (void)startRegionMonitoring {
    
    // if enable monitoring
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        // initialize location manager property
        self.locationManager = [[CLLocationManager alloc] init];
        
        // set delegate location manager to self
        self.locationManager.delegate = self;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
        // Parseサーバーからクエリを使って@"StoreName"を検索する
        PFQuery *query = [PFUser query];
        [query whereKey:@"StoreName" equalTo:[ud stringForKey:@"StoreName"]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            
            if (!error) {
                // uuidを取得
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:object[@"uuid"]];
                // make beacon
                self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:kIdentifier];
                // モニタリングスタート
                [self.locationManager startMonitoringForRegion:self.beaconRegion];
            } else {
                NSLog(@"Error : %@ %@", error, [error userInfo]);
            }
            
        }];
               
    }
}

// ロケーションマネージャーがモニタリングを完了した後呼ばれる
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSLog(@"Start monitoring for region");
    [self.locationManager requestStateForRegion:self.beaconRegion];
}

// ロケーションマネージャーがビーコンのモニタリングに失敗したとき、呼ばれる
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSLog(@"Failed monitoring with error:%@", error);
}

// ロケーションマネージャーがエラーを起こしたとき、ログを吐き出す。
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"didFailWithError:%@", error);
}

// 現在、受信側がリージョンに入っているかどうかの判別を行なうメソッド (既にリージョンに入っている状態でレンジングをスタートするときに使用)
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
            break;
        }
        case CLRegionStateOutside:
        case CLRegionStateUnknown:
        default:
            break;
    }
}

// リージョンに入ったとき、呼ばれる
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{
    
    // リージョンに入ったら...
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable])
    {
        // レンジングをスタート
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

// リージョンの外に出たとき、呼ばれる
- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    // リージョンから出たら...
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        // レンジングをストップする
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

// レンジングのメソッド。一番近いビーコンとの距離がimmediateになったらモーダルビューを呼ぶ。
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    
    if (beacons.count > 0) {
        
        // 一番近いビーコンのインスタンスをつくる
        CLBeacon *nearestBeacon =[beacons firstObject];
        
        // 距離がimmediateになったら
        if (CLProximityImmediate == nearestBeacon.proximity || CLProximityNear == nearestBeacon.proximity) {
            
            // 近くのビーコンのmajor,minorのIDを取得して、メソッドを実行
            [self detectWhichBeacons:nearestBeacon.major.integerValue
                    withMinor:nearestBeacon.minor.integerValue];
            
        
        
        }

    }
}

@end
