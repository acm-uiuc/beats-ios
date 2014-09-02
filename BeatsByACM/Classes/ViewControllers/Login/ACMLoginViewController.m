//
//  ACMLoginViewController.m
//  BeatsByACM
//
//  Created by Robert Maciej Pieta on 9/1/14.
//  Copyright (c) 2014 Zealous Amoeba. All rights reserved.
//

#import "ACMLoginViewController.h"
#import "ACMBeatsNetworkAPI.h"
#import "ACMUserManager.h"

@interface ACMLoginViewController() <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) ACMBeatsNetworkAPI *loginRequest;
@property (nonatomic, strong) ACMUserManager *sharedManager;
@end

@implementation ACMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedManager = [ACMUserManager sharedInstance];
    self.loginRequest = [[ACMBeatsNetworkAPI alloc] init];
    
    __weak ACMLoginViewController *weakSelf = self;
    self.loginRequest.completion = ^(NSError *error, NSData *data) {
        [weakSelf updateToData:data error:error];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.sharedManager.username && [self.sharedManager.username isEqualToString:@""]) {
        self.usernameTextField.text = self.sharedManager.username;
        self.passwordTextField.text = self.sharedManager.password;
    }
}

#pragma mark -
#pragma mark Request Methods

- (void)updateToData:(NSData *)data error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if(dict[@"reason"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:dict[@"reason"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else {
            [self.sharedManager setUsername:self.usernameTextField.text password:self.passwordTextField.text];
            
            self.sharedManager.session = dict[@"token"];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

#pragma mark -
#pragma mark Action Methods

- (IBAction)cancelAction:(id)sender {
    
}

- (IBAction)loginButton:(id)sender {
    [self.loginRequest loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
}

#pragma mark -
#pragma mark Request Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.usernameTextField]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else {
        if(![self.passwordTextField.text isEqualToString:@""]) {
            [self loginButton:nil];
        }
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark -
#pragma mark Touch Methods

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
