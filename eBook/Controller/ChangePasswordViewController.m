//
//  ChangePasswordViewController.m
//  eBook
//
//  Created by Sittikorn on 9/3/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "User.h"

@interface ChangePasswordViewController () <UserDelegate>
@property (strong, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (strong, nonatomic) IBOutlet UITextField *retypePassword;

- (IBAction)okAction:(id)sender;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Change Password";
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapRecognizer];
    
}
- (void) handleTapFrom: (UITapGestureRecognizer *) recognizer {
    // hide the keyboard
    [self.currentPasswordTextField resignFirstResponder];
    [self.passwordNewTextField resignFirstResponder];
    [self.retypePassword resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okAction:(id)sender {
    if ([self.passwordNewTextField.text length] < 5) {
        [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                    message:@"Please your new password with 6-20 characters"
                                   delegate:nil
                          cancelButtonTitle:@"Done"
                          otherButtonTitles:nil] show];
        
    } else {
        [User currentPassword:self.currentPasswordTextField.text changePassword:self.passwordNewTextField.text retype:self.retypePassword.text withDelegate:self];
    }
}

- (void)userdidchangePassWord:(BOOL)success {
    if (success) {
        [[[UIAlertView alloc] initWithTitle:@"Success"
                                    message:@"Your Password alreday Change"
                                   delegate:self
                          cancelButtonTitle:@"Done"
                          otherButtonTitles:nil] show];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Sorry"
                                    message:@"We have a problem \nSorry for inconvenient \nPlease try again"
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
