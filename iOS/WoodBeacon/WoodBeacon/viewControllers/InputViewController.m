//
//  InputViewController.m
//  WoodBeacon
//
//  Created by 加藤 未央 on 2/19/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

#import "InputViewController.h"
#import <Parse/Parse.h>
#import "NavViewController.h"


@interface InputViewController () <UITextFieldDelegate>

// property for signup
@property (nonatomic, weak) IBOutlet UITextField *userNameField;
@property (nonatomic, weak) IBOutlet UITextField *passWordField;
@property (nonatomic, weak) IBOutlet UITextField *eMailField;
@property (nonatomic, weak) IBOutlet UITextField *storeName;
@property (nonatomic, weak) IBOutlet UITextField *uuidField;


@end

@implementation InputViewController

#pragma mark Delegate Method

// エンターキーでキーボード画面を閉じる
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    [self.eMailField resignFirstResponder];
    
    return YES;
}

// 画面タッチでキーボード画面を閉じる
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    [self.eMailField resignFirstResponder];
}

#pragma mark Action Method


// ボタンを押したらsign up
- (IBAction)pushButton:(UIButton *)button
{
    [self signUp];
}


// sign up method
- (void)signUp {
    PFUser *user = [PFUser user];
    user.username = self.userNameField.text;
    user.password = self.passWordField.text;
    user.email = self.eMailField.text;
    
    // other fields can be set just like with PFObject
    user[@"StoreName"] = self.storeName.text;
    user[@"uuid"] = self.uuidField.text;

    
    // userdefaultsにuuidを保存
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:user[@"uuid"] forKey:@"uuid"];

    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // ストーリーボードを用いて、コードで画面遷移。
            NavViewController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
            [self presentViewController:nav animated:YES completion:nil];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error : %@", errorString);
        }
    }];
    
}


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
    
    // パスワードを隠す
    self.passWordField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
