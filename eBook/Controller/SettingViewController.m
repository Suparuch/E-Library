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

@interface SettingViewController ()
{
    NSArray *allMenu;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"Setting";
    
    allMenu = @[@"My Profile",@"Account",@"Notifications",@"Help",@"Report a Problem",@"About E-Book Store"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // Dismissing  ViewControllers clicking outside of it
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil])
        {
            // Remove the recognizer first so it's view.window is valid.
            [self.view.window removeGestureRecognizer:sender];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
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

@end
