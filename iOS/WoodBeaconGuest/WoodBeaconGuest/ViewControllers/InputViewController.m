//
//  InputViewController.m
//  WoodBeaconGuest
//
//  Created by 加藤 未央 on 2/27/14.
//  Copyright (c) 2014 加藤 未央. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *storeNameField;

@end

@implementation InputViewController

#pragma mark action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.storeNameField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.storeNameField resignFirstResponder];
    return YES;
}

- (IBAction)returnInputViewForeSegue:(UIStoryboardSegue *)segue
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.storeNameField.text forKey:@"StoreName"];
}

#pragma mark view

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
