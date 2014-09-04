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
#import "ORGContainerCell.h"
#import "ORGContainerCellView.h"

@interface StoreViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sampleData;
@property (strong, nonatomic) NSArray *keepBookDic;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation StoreViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Book Store";
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self curentUserSystem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure carousel
    _carousel.type = iCarouselTypeCylinder;
    _carousel.clipsToBounds = YES; //This is main point
    
    
    [self editButton];
    
    self.sampleData = [Books getAllBook];
    
    //NSLog(@"sempleData %@",self.sampleData);
    
    // Register the table cell
    [self.tableView registerClass:[ORGContainerCell class] forCellReuseIdentifier:@"ORGContainerCell"];
    
    // Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    
    CGFloat dummyViewHeight = 40;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, dummyViewHeight)];
    
    self.tableView.tableHeaderView = dummyView;
    self.tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
    
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemFromCollectionView" object:nil];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return 10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 200.0f, 150.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:@"page.png"];
        view.contentMode = UIViewContentModeCenter;
    
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
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
        NSLog(@"Login");
    } else {
        // show the signup or login screen
        LoginViewController *logIn = [[LoginViewController alloc]init];
        [self presentViewController:logIn animated:NO completion:nil];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sampleData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ORGContainerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORGContainerCell"];
    NSDictionary *cellData = [self.sampleData objectAtIndex:[indexPath section]];
    //NSLog(@"cellData %@",cellData);
    NSArray *articleData = [cellData objectForKey:@"articles"];
    [cell setCollectionData:articleData];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This code is commented out in order to allow users to click on the collection view cells.
    //    if (!self.detailViewController) {
    //        self.detailViewController = [[ORGDetailViewController alloc] initWithNibName:@"ORGDetailViewController" bundle:nil];
    //    }
    //    NSDate *object = _objects[indexPath.row];
    //    self.detailViewController.detailItem = object;
    //    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

#pragma mark UITableViewDelegate methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *sectionData = [self.sampleData objectAtIndex:section];
    NSString *header = [sectionData objectForKey:@"description"];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0;
}

#pragma mark - NSNotification to select table cell

- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSDictionary *cellData = [notification object];
    if (cellData)
    {
        //
        //[self.navigationController pushViewController:self.detailViewController animated:YES];
        
        DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
        controller.detailItem = cellData;
        
        controller.view.frame = self.navigationController.view.bounds;
        [self.navigationController.view addSubview:controller.view];
        [self.navigationController addChildViewController:controller];
        
        
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            controller.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            [controller didMoveToParentViewController:self];
        }];
    }
}


@end
