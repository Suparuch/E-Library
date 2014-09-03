//
//  StoreViewController.m
//  eBook
//
//  Created by Suparuch Sriploy on 9/2/14.
//  Copyright (c) 2014 Sittikorn. All rights reserved.
//

#import "StoreViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "Books.h"
#import "SettingTableViewController.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Book Store";
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self curentUserSystem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self editButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editButton
{
    /*
     UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LogoEdit.png"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(showEdit:)];*/
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(showSearchBar:)];
    settingButton.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    
//    self.navigationItem.rightBarButtonItems = @[settingButton];
}

-(IBAction)showSearchBar:(id)sender
{
    
    /*
     SettingViewController *controller = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
     controller.view.frame = self.navigationController.view.bounds;
     [self.navigationController.view addSubview:controller.view];
     [self.navigationController addChildViewController:controller];
     
     
     [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
     controller.view.alpha = 1.0;
     } completion:^(BOOL finished) {
     [controller didMoveToParentViewController:self];
     }];*/
    
}

- (void) curentUserSystem {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // [Books getAllBook];
    } else {
        // show the signup or login screen
        LoginViewController *logIn = [[LoginViewController alloc]init];
        [self presentViewController:logIn animated:NO completion:nil];
    }
}


@end
