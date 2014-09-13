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
#import "FXImageView.h"

@interface StoreViewController () <iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *titleView2;

@property (nonatomic, strong) iCarousel *carousel1;
@property (nonatomic, strong) iCarousel *carousel2;

@end

@implementation StoreViewController

@synthesize carousel1;
@synthesize carousel2;

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
    [self addTitleView];
    [self addTop10Book];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel1 = nil;
    self.carousel2 = nil;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel1.delegate = nil;
    carousel1.dataSource = nil;
    carousel2.delegate = nil;
    carousel2.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTitleView {
    
    //add background
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleView.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.7];
    [self.scrollView addSubview:titleView];
    
    
    //create carousel
    carousel1 = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    carousel1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    carousel1.type = iCarouselTypeRotary;
    carousel1.delegate = self;
    carousel1.dataSource = self;
    
    //add carousel to view
    [self.scrollView addSubview:carousel1];
    
}

- (void)addTop10Book {
    
    //add label top10
    UILabel *top10text = [[UILabel alloc]initWithFrame:CGRectMake(10, 165, self.scrollView.frame.size.width, 300)];
    top10text.text = @"Top10";
    top10text.font = [UIFont boldSystemFontOfSize:16];
    [self.scrollView addSubview:top10text];
    
    //add button to change to see top 100
    UIButton *seeAllButton = [[UIButton alloc]initWithFrame:CGRectMake(685, 306, 100, 18)];
    [seeAllButton setTitle:@"See All >" forState:UIControlStateNormal];
    seeAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(changeToSeeAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:seeAllButton];
    
    //add background
    self.titleView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 330, self.scrollView.frame.size.width, 200)];
    self.titleView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView2.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    [self.scrollView addSubview:self.titleView2];
    
    //create carousel2
    carousel2 = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    carousel2.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    carousel2.type = iCarouselTypeLinear;
    carousel2.delegate = self;
    carousel2.dataSource = self;
    
    //[self.scrollView addSubview:carousel2];
}

-(IBAction)changeToSeeAll:(id)sender {
    NSLog(@"come");
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    if (carousel == carousel1) {
        return 8;
    } else {
        return 5;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    if (view == nil)
    {
        FXImageView *imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 400.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 0.9f);
        imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 10.0f;
        view = imageView;
    }
    
    //set image
    ((FXImageView *)view).image = [UIImage imageNamed:@"book1.jpg"];
    
    return view;
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

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            if (carousel == carousel2)
            {
                //add a bit of spacing between the item views
                return value * 1.05f;
            }
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
    //get item index for button
    NSInteger index = [carousel1 indexOfItemViewOrSubview:sender];
    
    DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
    
    controller.view.frame = self.navigationController.view.bounds;
    [self.navigationController.view addSubview:controller.view];
    [self.navigationController addChildViewController:controller];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        controller.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [controller didMoveToParentViewController:self];
    }];
}


/*
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
 */

@end
