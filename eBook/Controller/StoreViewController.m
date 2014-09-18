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
#import "SettingViewController.h"
#import "FXImageView.h"
#import "SwipeView.h"
#import "SeeAllViewController.h"
#import "UIColor+HexString.h"
#import "CategoryBooks.h"
#import "ProfileViewController.h"
#import "AccountTableViewController.h"
#import "NotificationTableViewController.h"
#import "ReportViewController.h"
#import "AboutViewController.h"

@interface StoreViewController () <iCarouselDataSource,iCarouselDelegate,SwipeViewDataSource,SwipeViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *titleView2;
@property (strong, nonatomic) UIView *titleView3;
@property (strong, nonatomic) UIView *titleView4;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@property (strong, nonatomic) UISearchBar *mySearchBar;
@property (weak, nonatomic) UIToolbar *toolBar;
@property (nonatomic) PopupSearchTableViewController *recentSearchesController;
@property (nonatomic) UIPopoverController *recentSearchesPopoverController;

@property (nonatomic, strong) iCarousel *carousel1;
@property (nonatomic, strong) SwipeView *swipeView1;
@property (nonatomic, strong) SwipeView *swipeView2;
@property (nonatomic, strong) SwipeView *swipeView3;

@property (nonatomic, strong) NSArray *allBookData;
@property (nonatomic, strong) NSArray *getTop10;
@property (nonatomic, strong) NSArray *getAllAuthor;
@property (nonatomic, strong) NSArray *getNewRelease;
@property (nonatomic, strong) NSArray *getAllCategory;
@property (nonatomic, strong) NSArray *getBookRelation;

@property (nonatomic, strong) NSMutableArray *getBookCategory;
@property (nonatomic, strong) NSString *categoryName;

@property (nonatomic, assign) BOOL isFiltered;

@end

@implementation StoreViewController

@synthesize swipeView1,swipeView2,swipeView3,carousel1,mySearchBar,toolBar;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Book Store";
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    
    [self curentUserSystem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allBookData = [Books getAllBook];
    self.getAllAuthor = [Books getAuthorData];
    self.getTop10 = [Books getTop10Book:self.allBookData];
    self.getNewRelease = [Books getNewRelease:self.allBookData];
    self.getAllCategory = [CategoryBooks getAllCategory];
    
    NSLog(@"getTop10 %@",self.getAllAuthor);
    
    [self addTitleView];
    [self addTop10Book];
    [self addCategoryView];
    [self addNewsRelease];
    [self addSearchView];
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
    carousel1.type = iCarouselTypeCoverFlow2;
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
    if (self.getAllAuthor.count > 8) {
        return 8;
    } else {
        return self.getAllAuthor.count;
    }
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (view == nil)
    {
        FXImageView *imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 460.0f, 250.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.shadowOffset = CGSizeMake(0.0f, 2.0f);
        imageView.shadowBlur = 5.0f;
        imageView.cornerRadius = 10.0f;
        view = imageView;
    }
    
    //show placeholder
    ((FXImageView *)view).processedImage = [UIImage imageNamed:@"page.png"];
    
    // set imagebook
    PFFile *userImageFile = [[self.getAllAuthor objectAtIndex:index]valueForKey:@"authorimage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            ((FXImageView *)view).image = image;
        }
    }];
    
    view.contentMode = UIViewContentModeCenter;
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionWrap) {
        return YES;
    } else if (option == iCarouselOptionSpacing){
        return value * 2.0f;
    }
    return value;
}

// highlight image to open detail
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    
    NSString *authorName = [NSString stringWithFormat:@"More by %@",[[self.getAllAuthor objectAtIndex:index]valueForKey:@"authorname"]];
    seeAll.titleName = authorName;
    
    NSMutableArray *bookWithAuthorName = [[NSMutableArray alloc]initWithCapacity:self.allBookData.count];
    
    for (int i = 0 ; i < self.allBookData.count; i++) {
        if ([[[self.getAllAuthor objectAtIndex:index]valueForKey:@"objectId"] isEqualToString:[[self.allBookData objectAtIndex:i] valueForKeyPath:@"authorId.objectId"]]) {
            [bookWithAuthorName addObject:[self.allBookData objectAtIndex:i]];
            
        }
    }
    
    seeAll.bookData = bookWithAuthorName;;
    seeAll.getAllCategory = self.getAllCategory;
    seeAll.getAllAuthor = self.getAllAuthor;
    
    [self.navigationController pushViewController:seeAll animated:YES];
}


#pragma -
#pragma swipeView

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    if (self.allBookData.count >= 10) {
        return 10;
    } else if (swipeView == swipeView2) {
        return self.getAllCategory.count;
    } else {
        return self.allBookData.count;
    }
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
        if (swipeView == swipeView1) { // top 10
            
            view = [[NSBundle mainBundle] loadNibNamed:@"StoreBookView" owner:self options:nil][0];
            
            // set bookname
            UILabel *bookName = (UILabel *)[view viewWithTag:101];
            bookName.numberOfLines = 2;
            bookName.lineBreakMode = NSLineBreakByWordWrapping;
            bookName.text = [[self.getTop10 objectAtIndex:index]valueForKey:@"bookname"];
            bookName.adjustsFontSizeToFitWidth  = YES;
            
            // set author
            UILabel *author = (UILabel *)[view viewWithTag:102];
            for (int i = 0;i < self.getTop10.count; i++) {
                if ([[[self.getTop10 objectAtIndex:index]valueForKeyPath:@"authorId.objectId"] isEqualToString:[[self.getAllAuthor objectAtIndex:i] valueForKey:@"objectId"]]) {
                    author.text = [[self.getAllAuthor objectAtIndex:i] valueForKey:@"authorname"];
                    break;
                }
            }
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            [button addTarget:self action:@selector(top10Books:) forControlEvents:UIControlEventTouchUpInside];
            
            // set imagebook
            PFFile *userImageFile = [[self.getTop10 objectAtIndex:index]valueForKey:@"imagebook"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
            
        } else if (swipeView == swipeView2) { // category
            
            view = [[NSBundle mainBundle] loadNibNamed:@"CategoryView" owner:self options:nil][0];
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            [button setTitle:[[self.getAllCategory objectAtIndex:index]valueForKey:@"categoryname"] forState:UIControlStateNormal];
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 6;
            button.clipsToBounds = YES;
            [button layer].cornerRadius = 10.0f;
            button.layer.borderColor = [UIColor_HexString colorFromHexString:@"#3476D8"].CGColor;
            [button addTarget:self action:@selector(swipeCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (swipeView == swipeView3) { // news release
            
            view = [[NSBundle mainBundle] loadNibNamed:@"StoreBookView" owner:self options:nil][0];
            
            // set bookname
            UILabel *bookName = (UILabel *)[view viewWithTag:101];
            bookName.numberOfLines = 2;
            bookName.lineBreakMode = NSLineBreakByWordWrapping;
            bookName.text = [[self.getNewRelease objectAtIndex:index]valueForKey:@"bookname"];
            bookName.adjustsFontSizeToFitWidth  = YES;
            
            // set author
            UILabel *author = (UILabel *)[view viewWithTag:102];
            for (int i = 0;i < self.getNewRelease.count; i++) {
                if ([[[self.getNewRelease objectAtIndex:index]valueForKeyPath:@"authorId.objectId"] isEqualToString:[[self.getAllAuthor objectAtIndex:i] valueForKey:@"objectId"]]) {
                    author.text = [[self.getAllAuthor objectAtIndex:i] valueForKey:@"authorname"];
                    break;
                }
            }
            
            // set button to view detail
            UIButton *button = (UIButton *)[view viewWithTag:301];
            
            [button addTarget:self action:@selector(newReleaseButton:) forControlEvents:UIControlEventTouchUpInside];
            
            // set imagebook
            PFFile *userImageFile = [[self.getNewRelease objectAtIndex:index]valueForKey:@"imagebook"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:imageData];
                    [button setBackgroundImage:image forState:UIControlStateNormal];
                }
            }];
        }
    }
    
    return view;
}

#pragma mark -
#pragma mark Button tap event

// see all 10 top
-(IBAction)changeToSeeAll:(id)sender {
    [self openSeeAll:self.getTop10 titleName:@"All Book"];
}

// see all New Release
-(IBAction)changeToSeeAllNewRelease:(id)sender {
    
    [self openSeeAll:self.getNewRelease titleName:@"All Books New Release"];
}


-(IBAction)top10Books:(id)sender {
    
    NSInteger index = [swipeView1 indexOfItemViewOrSubview:sender];
    
    [self openDetailBook:self.getTop10 index:index];
    
    
}
// new release Book Detail
-(IBAction)newReleaseButton:(id)sender{
    
    NSInteger index = [swipeView3 indexOfItemViewOrSubview:sender];
    
    [self openDetailBook:self.getNewRelease index:index];
    
}

// see Category Book
-(IBAction)swipeCategoryButton:(id)sender {
    
    NSInteger index = [swipeView2 indexOfItemViewOrSubview:sender];
    
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    
    self.getBookCategory = [[NSMutableArray alloc]initWithCapacity:self.getTop10.count];
    
    for (int i = 0; i < self.allBookData.count; i++) {
        
        if ([[[self.getAllCategory objectAtIndex:index]valueForKey:@"objectId"] isEqualToString:[[self.allBookData objectAtIndex:i] valueForKeyPath:@"categoryId.objectId"]]) {
            [self.getBookCategory addObject:[self.allBookData objectAtIndex:i]];
        }
    }
    
    seeAll.bookData = self.getBookCategory;
    seeAll.titleName = [[self.getAllCategory objectAtIndex:index]valueForKey:@"categoryname"];
    seeAll.getAllAuthor = self.getAllAuthor;
    seeAll.getAllCategory = self.getAllCategory;
    
    [self.navigationController pushViewController:seeAll animated:YES];
    
}

- (void)openSeeAll:(NSArray *)bookArray titleName:(NSString *)title{
    
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    
    seeAll.titleName = title;
    seeAll.bookData = bookArray;
    seeAll.getAllAuthor = self.getAllAuthor;
    seeAll.getAllCategory = self.getAllCategory;
    
    [self.navigationController pushViewController:seeAll animated:YES];
}

// open setting
- (IBAction)showEdit:(id)sender {
    
    SettingViewController *controller = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    
    controller.view.frame = self.view.bounds;
    
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    [self addChildViewController:controller];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.view addSubview:navController.view];
    [controller didMoveToParentViewController:self];
    [self addChildViewController:navController];
}



// open detail book
- (void)openDetailBook:(NSArray *)bookData index:(NSInteger)index{
    
    DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
    controller.detailItem = [bookData objectAtIndex:index];
    controller.delegate = self;
    controller.authorData = self.getAllAuthor;
    controller.categoryData = self.getAllCategory;
    
    NSLog(@"getAllAuthor %@",self.getAllAuthor);
    
    for (int i = 0; i < bookData.count; i++) {
        
        if ([[[self.getAllCategory objectAtIndex:i]valueForKey:@"objectId"] isEqualToString:[[bookData objectAtIndex:i] valueForKeyPath:@"categoryId.objectId"]]) {
            
            controller.cateogryName = [[self.getAllCategory objectAtIndex:i]valueForKey:@"categoryname"];
            break;
        }
    }
    
    self.getBookRelation = [Books getRelationBook:bookData authorname:[[bookData objectAtIndex:index]valueForKeyPath:@"authorId.objectId"]];
    
    controller.bookDataRelation = self.getBookRelation;
    
    for (int i = 0;i < bookData.count; i++) {
        if ([[[bookData objectAtIndex:index]valueForKeyPath:@"authorId.objectId"] isEqualToString:[[self.getAllAuthor objectAtIndex:i] valueForKey:@"objectId"]]) {
            controller.nameAuthor = [[self.getAllAuthor objectAtIndex:i] valueForKey:@"authorname"];
            break;
        }
    }
    
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

#pragma mark - UISearchBarDelegate


- (void)addSearchView {
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 150.0f, 30.0f)];
    mySearchBar.barStyle = UIBarStyleDefault;
    mySearchBar.delegate = self;
    [mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    mySearchBar.placeholder = @"Search Store";
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LogoEdit.png"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(showEdit:)];
    
    self.navigationItem.rightBarButtonItems = @[editButton,[[UIBarButtonItem alloc] initWithCustomView:mySearchBar]];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar {
    
    // Create the popover if it is not already open.
    if (self.recentSearchesPopoverController == nil) {
        
        PopupSearchTableViewController *popUp = [[PopupSearchTableViewController alloc]initWithNibName:@"PopupSearchTableViewController" bundle:nil];
        popUp.allBookbData = self.allBookData;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:popUp];
        
        self.recentSearchesController = (PopupSearchTableViewController *)[navigationController topViewController];
        self.recentSearchesController.delegate = self;
        
        // Create the popover controller to contain the navigation controller.
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
        popover.delegate = self;
        
        // Ensure the popover is not dismissed if the user taps in the search bar by adding
        // the search bar to the popover's list of pass-through views.
        popover.passthroughViews = @[mySearchBar];
        
        self.recentSearchesPopoverController = popover;
    }
    
    // Display the popover.
    [self.recentSearchesPopoverController presentPopoverFromRect:[mySearchBar bounds] inView:mySearchBar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.recentSearchesController filterResultsUsingString:searchText];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    self.recentSearchesPopoverController = nil;
    [mySearchBar resignFirstResponder];
}

- (void)recentSearchesController:(PopupSearchTableViewController *)controller didSelectString:(NSString *)searchString {
    
    mySearchBar.text = searchString;
    [self finishSearchWithString:searchString];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    
    // When the search button is tapped, add the search term to recents and conduct the search.
    NSString *searchString = [mySearchBar text];
    [self finishSearchWithString:searchString];
}

- (void)finishSearchWithString:(NSString *)book {
    
    // Conduct the search. In this case, simply report the search term used.
    [self.recentSearchesPopoverController dismissPopoverAnimated:YES];
    self.recentSearchesPopoverController = nil;
    
    [mySearchBar resignFirstResponder];
    
    for (int i = 0; i < self.allBookData.count; i ++) {
        
        if ([[[self.allBookData objectAtIndex:i]valueForKey:@"bookname"] isEqualToString:book]) {
            
            DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
            controller.detailItem = [self.allBookData objectAtIndex:i];
            controller.delegate = self;
            controller.view.frame = self.navigationController.view.bounds;
            
            for (int i = 0; i < self.getNewRelease.count; i++) {
                
                if ([[[self.getAllCategory objectAtIndex:i]valueForKey:@"objectId"] isEqualToString:[[self.allBookData objectAtIndex:i] valueForKeyPath:@"categoryId.objectId"]]) {
                    controller.cateogryName = [[self.getAllCategory objectAtIndex:i]valueForKey:@"categoryname"];
                    break;
                }
            }
            
            
            self.view.frame = controller.view.frame;
            
            [self addChildViewController:controller];
            [self.view addSubview:controller.view];
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                controller.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                [controller didMoveToParentViewController:self];
            }];
            
        }
    }
}


#pragma -
#pragma relation Book

-(void)openRelationDataBook:(DetailBookViewController *)controller bookData:(NSArray *)bookData authorName:(NSString *)objectId{
    
    [self openDetail:bookData authorName:objectId];
    
}


- (void)openDetail:(NSArray *)bookData authorName:(NSString *)objectId{
    
    DetailBookViewController *controller = [[DetailBookViewController alloc] initWithNibName:@"DetailBookViewController" bundle:nil];
    
    controller.detailItem = bookData;
    controller.authorData = self.getAllAuthor;
    NSLog(@"getAllAuthor %@",self.getAllAuthor);
    controller.delegate = self;
    
    self.getBookRelation = [Books getRelationBook:self.getNewRelease authorname:objectId];
    
    controller.bookDataRelation = self.getBookRelation;
    
    for (int i = 0;i < self.getNewRelease.count; i++) {
        if ([objectId isEqualToString:[[self.getAllAuthor objectAtIndex:i] valueForKey:@"objectId"]]) {
            controller.nameAuthor = [[self.getAllAuthor objectAtIndex:i] valueForKey:@"authorname"];
            break;
        }
    }
    
    
    controller.view.frame = self.navigationController.view.bounds;
    
    for (int i = 0; i < self.getNewRelease.count; i++) {
        
        if ([[[self.getAllCategory objectAtIndex:i]valueForKey:@"objectId"] isEqualToString:[bookData valueForKeyPath:@"categoryId.objectId"]]) {
            controller.cateogryName = [[self.getAllCategory objectAtIndex:i]valueForKey:@"categoryname"];
            break;
        }
    }
    
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
@end
