//
//  StartViewController.m
//  WoodBeacon
//
//  Created by 加藤 未央 on 2/19/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

#import "StartViewController.h"
#import "NavViewController.h"
#import <Parse/Parse.h>

@interface StartViewController () <UITextFieldDelegate>

// textField
@property (nonatomic) IBOutlet UITextField *userNameField;
@property (nonatomic) IBOutlet UITextField *passWordField;

// navigationController
@property (nonatomic) NavViewController *nav;

@end

@implementation StartViewController

#pragma mark action methods

// segueを使ってstartViewに戻る。
-(IBAction)returnStartViewForSegue:(UIStoryboardSegue *)segue
{
    
}

// ボタンが押されたら、ログイン認証のメソッドを呼び出す。
- (IBAction)pushButton:(UIButton *)button
{
    [PFUser logInWithUsernameInBackground:self.userNameField.text password:self.passWordField.text
                                    block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"nav"];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            // The login failed. Check error to see why.
            // UsernameまたはPasswordが間違った場合にアラートを表示
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"UsernameまたはPasswordが間違っています!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"error : %@", error);
        }
    }];
}

// エンターキーを押すことで、キーボード画面を閉じる
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    
    return YES;
}

// キーボード以外の画面をタッチすることで、キーボードを閉じる
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
}

#pragma mark init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark view

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
