//
//  WBMainViewController.m
//  iBeacon_test
//
//  Created by 加藤 未央 on 12/31/13.
//  Modified 2014/01/03
//  Copyright (c) 2013 加藤 未央. All rights reserved.
//

#import "NewsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>


@interface NewsViewController () <CLLocationManagerDelegate,
                                        UITextFieldDelegate,
                                        UITextViewDelegate,
                                        UIScrollViewDelegate>

// UITextField
@property (weak, nonatomic) IBOutlet UITextField *majorField;
@property (weak, nonatomic) IBOutlet UITextField *minorField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;

// UITextView
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;

@end


@implementation NewsViewController


#pragma mark - Action

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}


- (IBAction)pushButton:(UIButton *)sender {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    // parse上にセーブ
    PFObject *beacons = [PFObject objectWithClassName:@"Beacons"];
   // beacons[@"UUID"] = [ud stringForKey:@"uuid"];
    beacons[@"Name"] = _detailItem;
    beacons[@"Major"] = self.majorField.text;
    beacons[@"Minor"] = self.minorField.text;
    beacons[@"Title"] = self.titleField.text;
    beacons[@"Desctiption"] = self.descriptionView.text;
    
    [beacons saveInBackground];
    NSLog(@"%@", beacons);
    
}

//テキストフィールドがのエンターキー押したら呼ばれる
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameField resignFirstResponder];
    [self.majorField resignFirstResponder];
    [self.minorField resignFirstResponder];
    [self.titleField resignFirstResponder];
    return YES;
}


// 画面がタッチされたら文字入力を終了する
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.descriptionView resignFirstResponder];
    [self.nameField resignFirstResponder];
    [self.majorField resignFirstResponder];
    [self.minorField resignFirstResponder];
    [self.titleField resignFirstResponder];
}




#pragma mark - View

// be called After loaded view
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // テキストフィールドのデリゲートを設定
    self.nameField.delegate = self;
    self.majorField.delegate = self;
    self.minorField.delegate = self;
    self.titleField.delegate = self;
    
    // テキストビューのデリゲートを設定
    self.descriptionView.delegate = self;
    self.nameField.text = _detailItem;
    self.title = _detailItem;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

