//
//  ChangeEmailViewController.m
//  eBook
//
//  Created by Sittikorn on 9/3/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "ChangeEmailViewController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface ChangeEmailViewController () <UserDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *currentEmail;
@property (strong, nonatomic) IBOutlet UITextField *emailNewTextField;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *retypeTextField;
- (IBAction)updateAction:(id)sender;

@end

@implementation ChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Change Email";
    
    [self setAllUI];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapRecognizer];

}

- (void) handleTapFrom: (UITapGestureRecognizer *) recognizer {
    // hide the keyboard
    [self.emailNewTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.retypeTextField resignFirstResponder];
}

-(void)setAllUI {
    self.currentEmail.text = [PFUser currentUser].email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateAction:(id)sender {
    [User newEmail:self.emailNewTextField.text password:self.passwordTextField.text reTypePassword:self.retypeTextField.text withDelegate:self];
}

-(void)userdidChange:(BOOL)didChange {
    if (didChange) {
        [[[UIAlertView alloc] initWithTitle:@"Success"
                                    message:@"Email alreday Change"
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
