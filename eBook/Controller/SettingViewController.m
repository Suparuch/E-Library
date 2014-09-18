//
//  SettingViewController.m
//  eBook
//
//  Created by Sittikorn on 9/17/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "SettingViewController.h"
#import "ProfileViewController.h"
#import "AccountTableViewController.h"
#import "NotificationTableViewController.h"
#import "ReportViewController.h"
#import "AboutViewController.h"

@interface SettingViewController () <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myTableVIew;
@property (strong, nonatomic) UINavigationBar *navbar;
@end

@implementation SettingViewController
{
    NSArray *allMenu;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Setting";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.myTableVIew.delegate = self;
    self.myTableVIew.dataSource = self;
    
    allMenu = @[@"My Profile",@"Account",@"Notifications",@"Help",@"Report a Problem",@"About E-Book Store"];
    
    [self changeBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackGround {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allMenu.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = allMenu[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        ProfileViewController *profile = [[ProfileViewController alloc]initWithNibName:@"ProfileViewController" bundle:nil];
        [self.navigationController pushViewController:profile animated:YES];
        
    } else if (indexPath.row == 1){
        AccountTableViewController *account = [[AccountTableViewController alloc]initWithNibName:@"AccountTableViewController" bundle:nil];
        [self.navigationController pushViewController:account animated:YES];
    } else if (indexPath.row == 2) {
        NotificationTableViewController *noti = [[NotificationTableViewController alloc]initWithNibName:@"NotificationTableViewController" bundle:nil];
        [self.navigationController pushViewController:noti animated:YES];
    } else if (indexPath.row == 4) {
        ReportViewController *report = [[ReportViewController alloc]initWithNibName:@"ReportViewController" bundle:nil];
        [self.navigationController pushViewController:report animated:YES];
    } else if (indexPath.row == 5) {
        AboutViewController *about = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
    }
    
    [self.myTableVIew deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changeBackground {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.myTableVIew layer].cornerRadius = 10;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)close:(id)sender {
    [self willMoveToParentViewController:nil];
    [self beginAppearanceTransition:NO animated:YES];
    [UIView  animateWithDuration:0.3
                      animations:^(void){
                          self.view.alpha = 0.0;
                      }
                      completion:^(BOOL finished) {
                          [self endAppearanceTransition];
                          [self.view removeFromSuperview];
                          [self removeFromParentViewController];
                      }];
}

@end
