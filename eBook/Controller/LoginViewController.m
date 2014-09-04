//
//  LoginViewController.m
//  eBook
//
//  Created by Suparuch Sriploy on 9/2/14.
//  Copyright (c) 2014 Sittikorn. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController () <UserDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginAction:(id)sender;
- (IBAction)forgotAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    [User loginWithSystem:self.usernameTextField.text withPassword:self.passwordTextField.text withDelegate:self];
}

- (IBAction)forgotAction:(id)sender {
    [User resetPassword:self.usernameTextField.text];
}

- (void) userDidLogin:(BOOL)loggedIn {
    // Did we login successfully ?
    if (loggedIn) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    } else {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"The login failed. Check error to see why."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}
@end
