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
#import "SwipeView.h"
#import "SeeAllViewController.h"

@interface StoreViewController () <iCarouselDataSource,iCarouselDelegate,SwipeViewDataSource,SwipeViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *titleView2;
@property (strong, nonatomic) UIView *titleView3;
@property (strong, nonatomic) UIView *titleView4;

@property (nonatomic, strong) iCarousel *carousel1;
@property (nonatomic, strong) SwipeView *swipeView1;
@property (nonatomic, strong) SwipeView *swipeView2;
@property (nonatomic, strong) SwipeView *swipeView3;

@end

@implementation StoreViewController

@synthesize swipeView1,swipeView2,swipeView3,carousel1;

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
    [self addCategoryView];
    [self addNewsRelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel1 = nil;
    self.swipeView1 = nil;
    self.swipeView2 = nil;
    self.swipeView3 = nil;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel1.delegate = nil;
    carousel1.dataSource = nil;
    swipeView1.delegate = nil;
    swipeView1.dataSource = nil;
    swipeView2.delegate = nil;
    swipeView2.dataSource = nil;
    swipeView3.delegate = nil;
    swipeView3.dataSource = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)addTitleView {
    
    self.mainView = [[UIView alloc]initWithFrame:self.scrollView.bounds];
    [self.scrollView addSubview:self.mainView];
    
    //add background
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    self.titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.7];
    
    //create carousel
    carousel1 = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 300)];
    carousel1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    carousel1.type = iCarouselTypeRotary;
    carousel1.clipsToBounds = YES;
    carousel1.delegate = self;
    carousel1.dataSource = self;
    carousel1.scrollEnabled = YES;
    
    //add carousel to view
    [self.titleView addSubview:carousel1];
    [self.mainView addSubview:self.titleView];
    
}

- (void)addTop10Book {
    
    //add label top10
    UILabel *top10text = [[UILabel alloc]initWithFrame:CGRectMake(10, 165, self.scrollView.frame.size.width, 300)];
    top10text.text = @"Top10";
    top10text.font = [UIFont boldSystemFontOfSize:16];
    [self.mainView addSubview:top10text];
    
    //add button to change to see top 20
    UIButton *seeAllButton = [[UIButton alloc]initWithFrame:CGRectMake(685, 306, 100, 18)];
    [seeAllButton setTitle:@"See All >" forState:UIControlStateNormal];
    seeAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(changeToSeeAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:seeAllButton];
    
    //add background
    self.titleView2= [[UIView alloc] initWithFrame:CGRectMake(0, 330, self.scrollView.frame.size.width, 200)];
    self.titleView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    
    swipeView1 = [[SwipeView alloc] initWithFrame:CGRectMake(0,0, self.titleView2.frame.size.width, self.titleView2.frame.size.height)];
    swipeView1.alignment = SwipeViewAlignmentEdge;
    swipeView1.pagingEnabled = YES;
    swipeView1.itemsPerPage = 10;
    swipeView1.truncateFinalPage = YES;
    swipeView1.delegate = self;
    swipeView1.dataSource = self;
    
    [self.titleView2 addSubview:swipeView1];
    [self.mainView addSubview:self.titleView2];
}

- (void)addCategoryView {
    
    //add Category Label
    UILabel *top10text = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 400.0f, self.scrollView.frame.size.width, 300.0f)];
    top10text.text = @"Browse Category";
    top10text.font = [UIFont boldSystemFontOfSize:16];
    [self.mainView addSubview:top10text];
    
    //add background
    self.titleView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 530.0f, self.scrollView.frame.size.width, 150)];
    self.titleView3.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView3.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    
    swipeView2 = [[SwipeView alloc] initWithFrame:CGRectMake(0,16.0f, self.titleView3.frame.size.width, self.titleView3.frame.size.height)];
    swipeView2.alignment = SwipeViewAlignmentEdge;
    swipeView2.pagingEnabled = YES;
    swipeView2.itemsPerPage = 5;
    swipeView2.truncateFinalPage = YES;
    swipeView2.delegate = self;
    swipeView2.dataSource = self;
    
    [self.titleView3 addSubview:swipeView2];
    [self.mainView addSubview:self.titleView3];
    
}

- (void) addNewsRelease {
    
    //add New Release Label
    UILabel *top10text = [[UILabel alloc]initWithFrame:CGRectMake(10.0f, 545.0f, self.scrollView.frame.size.width, 300.0f)];
    top10text.text = @"News Release";
    top10text.font = [UIFont boldSystemFontOfSize:16];
    [self.mainView addSubview:top10text];
    
    //add background
    self.titleView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 710.0f, self.scrollView.frame.size.width, 200.0f)];
    self.titleView4.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView4.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.1];
    
    //add button to change to see top 20
    UIButton *seeAllButton = [[UIButton alloc]initWithFrame:CGRectMake(685, 686 , 100, 18)];
    [seeAllButton setTitle:@"See All >" forState:UIControlStateNormal];
    seeAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [seeAllButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(changeToSeeAllNewRelease:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:seeAllButton];
    
    swipeView3 = [[SwipeView alloc] initWithFrame:CGRectMake(0,0, self.titleView4.frame.size.width, self.titleView4.frame.size.height)];
    swipeView3.alignment = SwipeViewAlignmentEdge;
    swipeView3.pagingEnabled = YES;
    swipeView3.itemsPerPage = 10;
    swipeView3.truncateFinalPage = YES;
    swipeView3.delegate = self;
    swipeView3.dataSource = self;
    
    [self.titleView4 addSubview:swipeView3];
    [self.mainView addSubview:self.titleView4];
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 8;
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (carousel == carousel1) {
        
        
        FXImageView *imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 420.0f, 280.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 10.0f;
        
        self.titleView = imageView;
        
        ((FXImageView *)self.titleView).image = [UIImage imageNamed:@"book1.jpg"];
        
        return self.titleView;
        
    }
    
    return self.mainView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
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


#pragma -
#pragma swipeView

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    if (swipeView == swipeView1) {
        return 10;
    } else if (swipeView == swipeView3 ){
        return 10;
    } else {
        return 5;
    }
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        if (swipeView == swipeView1) {
            
            view = [[NSBundle mainBundle] loadNibNamed:@"StoreBookView" owner:self options:nil][0];
            
            
            // set bookname
            UILabel *bookName = (UILabel *)[view viewWithTag:101];
            bookName.text = @"เมื่อวาน";
            
            // set author
            UILabel *author = (UILabel *)[view viewWithTag:102];
            author.text = @"ไปไหน";
            
            // set imagebook
            UIImage *image = [UIImage imageNamed:@"page.png"];
            
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(swipeButton:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (swipeView == swipeView2) {
            
            view = [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil][0];
            
            // set imagebook
            UIImage *image = [UIImage imageNamed:@"book1.jpg"];
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.clipsToBounds = YES;
            [button layer].cornerRadius = 10.0f;
            [button addTarget:self action:@selector(swipeCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (swipeView == swipeView3) {
            
            view = [[NSBundle mainBundle] loadNibNamed:@"StoreBookView" owner:self options:nil][0];
            
            // set bookname
            UILabel *bookName = (UILabel *)[view viewWithTag:101];
            bookName.text = @"เมื่อวาน";
            
            // set author
            UILabel *author = (UILabel *)[view viewWithTag:102];
            author.text = @"ไปไหน";
            
            // set imagebook
            UIImage *image = [UIImage imageNamed:@"page.png"];
            
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(newReleaseButton:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    return view;
}

#pragma mark -
#pragma mark Button tap event

// see highlight detail
-(IBAction)carouselToSeeHighlightDetail:(id)sender {
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    [self.navigationController pushViewController:seeAll animated:YES];
}

// see all 10 top
-(IBAction)changeToSeeAll:(id)sender {
    NSLog(@"come Top 10");
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    [self.navigationController pushViewController:seeAll animated:YES];
}

// see all New Release
-(IBAction)changeToSeeAllNewRelease:(id)sender {
    
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    [self.navigationController pushViewController:seeAll animated:YES];
    
    NSLog(@"Come New Release");
}

// new release Book Detail
-(IBAction)newReleaseButton:(id)sender{
    NSInteger index = [swipeView3 indexOfItemViewOrSubview:sender];
    
    DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
    controller.view.frame = self.navigationController.view.bounds;
    
    UINavigationController *childNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    childNavController.view.frame = controller.view.frame;
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        controller.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [controller didMoveToParentViewController:self];
    }];
}


-(IBAction)swipeButton:(id)sender {
    
    NSInteger index = [swipeView1 indexOfItemViewOrSubview:sender];
    
    
    DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
    controller.view.frame = self.navigationController.view.bounds;
    
    UINavigationController *childNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    childNavController.view.frame = controller.view.frame;
    
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        controller.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [controller didMoveToParentViewController:self];
    }];

    
}

// see Category Book
-(IBAction)swipeCategoryButton:(id)sender {
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    [self.navigationController pushViewController:seeAll animated:YES];
    
}
@end
