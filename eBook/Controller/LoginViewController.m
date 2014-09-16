//
//  LoginViewController.m
//  eBook
//
//  Created by Suparuch Sriploy on 9/2/14.
//  Copyright (c) 2014 Sittikorn. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "StoreViewController.h"
#import "ShelfViewController.h"
#import "SettingTableViewController.h"

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
        [self dismissViewControllerAnimated:YES completion:nil];
        [self ShowNav];
        
        
    } else {
        // Show error alert
        [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                    message:@"The login failed. Check error to see why."
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
}

-(void)ShowNav
{
    StoreViewController *StoreView = [[StoreViewController alloc]init];
    ShelfViewController *shelfView = [[ShelfViewController alloc] init];
    SettingTableViewController *category = [[SettingTableViewController alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:StoreView];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:shelfView];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:category];
    
    NSArray *viewControllersArray = [[NSArray alloc] initWithObjects:nav1 , nav2, nav3, nil];
    
    self.tabController = [[UITabBarController alloc] init];
    
    [self.tabController setViewControllers:viewControllersArray animated:YES];
    [self presentViewController:self.tabController animated:YES completion:nil];
    
}

@end
