//
//  FirstViewController.m
//  WoodBeaconGuest
//
//  Created by 加藤 未央 on 2/24/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

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
    // ユーザーのテキストビューへの書込み禁止
    self.titleView.editable = NO;
    self.descriptionView.editable = NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
