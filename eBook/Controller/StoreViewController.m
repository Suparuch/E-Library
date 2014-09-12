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
#import "BooksManager.h"

@interface StoreViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) iCarousel *carousel1;
@property (nonatomic, strong) iCarousel *carousel2;

@property (nonatomic, assign) BOOL wrap;


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
    //[self addTop10Book];
    [BooksManager searchBookWithAuthor:@"Jakrit Tamnakpho"];

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
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.scrollView addSubview:titleView];
    
    
    //create carousel
    carousel1 = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    carousel1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel1.type = iCarouselTypeRotary;
    carousel1.delegate = self;
    carousel1.dataSource = self;
    
    _wrap = !_wrap;
    
    //add carousel to view
    [self.scrollView addSubview:carousel1];
    
}

- (void)addTop10Book {
    
    //add background
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 600, self.scrollView.frame.size.width, 300)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.scrollView addSubview:titleView];
    
    //create carousel
    carousel2 = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    carousel2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel2.type = iCarouselTypeLinear;
    carousel2.delegate = self;
    carousel2.dataSource = self;
    
    [self.scrollView addSubview:carousel2];
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
    UIButton *button = (UIButton *)view;
    if (button == nil)
    {
        //no button available to recycle, so create new one
        UIImage *image = [UIImage imageNamed:@"book1.jpg"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return button;
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

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
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
