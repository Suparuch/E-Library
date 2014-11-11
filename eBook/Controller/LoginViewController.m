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
#import "SettingViewController.h"



@interface LoginViewController () <UserDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;
- (IBAction)forgotAction:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self customView];
}

- (void) customView {
    
    UIView *usernameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.usernameTextField.leftView = usernameView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.65];
    self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName: color}];
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordTextField.leftView = passwordView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.loginButton.layer.cornerRadius = 10;
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
    SettingViewController *category = [[SettingViewController alloc]init];
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:StoreView];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:shelfView];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:category];
    
    NSArray *viewControllersArray = [[NSArray alloc] initWithObjects:nav1 , nav2, nav3, nil];
    
    self.tabController = [[UITabBarController alloc] init];
    
    [self.tabController setViewControllers:viewControllersArray animated:YES];
    [self presentViewController:self.tabController animated:YES completion:nil];
    
}

@end
