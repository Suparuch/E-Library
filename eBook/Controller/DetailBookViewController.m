//
//  DetailBookViewController.m
//  eBook
//
//  Created by Sittikorn on 9/3/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "DetailBookViewController.h"
#import "InformationCell.h"
#import "ReviewCell.h"
#import "UIColor+HexString.h"
#import <Parse/Parse.h>
#import "BooksManager.h"
#import "SwipeView.h"
#import "SeeAllViewController.h"

@interface DetailBookViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,SwipeViewDataSource,SwipeViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *dataView;
@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *publishName;
@property (weak, nonatomic) IBOutlet UILabel *numberPage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentSelect;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;

@property (nonatomic, strong) SwipeView *swipeView1;
@property (nonatomic, strong) UIView *titleView1;
@property (nonatomic, strong) UILabel *top10text;
@property (nonatomic, strong) UIButton *seeAllButton;

- (IBAction)segmentAction:(id)sender;
- (IBAction)downloadAction:(id)sender;

@end

@implementation DetailBookViewController

@synthesize swipeView1,top10text,seeAllButton,titleView1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeBackground];
    [self createUI];
    self.segmentSelect.selectedSegmentIndex = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InformationCell" bundle:nil] forCellReuseIdentifier:@"informationCell"];
    
    //NSLog(@"authorData %@",self.authordata);
    //NSLog(@"authorName %@",self.nameAuthor);
}

- (void)addRelation {
    
    //add label top10
    top10text = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, self.view.frame.size.width, 310)];
    top10text.text = [NSString stringWithFormat:@"More by %@",self.nameAuthor];
    top10text.font = [UIFont boldSystemFontOfSize:16];
    [self.dataView addSubview:top10text];
    
    //add button to change to see top 20
    seeAllButton = [[UIButton alloc]initWithFrame:CGRectMake(570, 307, 100, 18)];
    [seeAllButton setTitle:@"See All >" forState:UIControlStateNormal];
    seeAllButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [seeAllButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [seeAllButton addTarget:self action:@selector(seeAllRelated:) forControlEvents:UIControlEventTouchUpInside];
    [self.dataView addSubview:seeAllButton];
    
    //add background
    self.titleView1= [[UIView alloc] initWithFrame:CGRectMake(0, 330, self.dataView.frame.size.width, 200)];
    self.titleView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleView1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    
    swipeView1 = [[SwipeView alloc] initWithFrame:CGRectMake(0,0, self.titleView1.frame.size.width, self.titleView1.frame.size.height)];
    swipeView1.alignment = SwipeViewAlignmentEdge;
    swipeView1.pagingEnabled = YES;
    swipeView1.itemsPerPage = 10;
    swipeView1.truncateFinalPage = YES;
    swipeView1.delegate = self;
    swipeView1.dataSource = self;
    
    [self.titleView1 addSubview:swipeView1];
    [self.dataView addSubview:self.titleView1];
}


- (void)changeBackground {
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.dataView layer].cornerRadius = 10;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI {
    
    PFFile *userImageFile = [self.detailItem valueForKey:@"imagebook"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageVIew.image = image;
        }
    }];
    
    [self.imageVIew layer].borderWidth = 1;
    self.bookName.text = [self.detailItem valueForKey:@"bookname"];
    self.bookName.adjustsFontSizeToFitWidth  = YES;
    
    self.authorName.text = self.nameAuthor;
    self.publishName.text = [self.detailItem valueForKey:@"publisher"];
    self.numberPage.text = [[self.detailItem valueForKey:@"page"]stringValue];
    
    NSArray *bookAdd = [BooksManager getAllBookDidAdd];
    for (int i = 0; i < bookAdd.count; i++) {
        NSString *bookname = [[bookAdd objectAtIndex:i]valueForKey:@"bookname"];
        
        if ([[self.detailItem valueForKey:@"bookname"] isEqualToString:bookname]) {
            [self.downloadButton setFrame:CGRectMake(224,65,63 + 19, 26)];
            self.downloadButton.layer.borderWidth = 1;
            self.downloadButton.layer.cornerRadius = 6;
            self.downloadButton.layer.masksToBounds = YES;
            self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.downloadButton setTitle:@"GOT BOOK" forState:UIControlStateNormal];
            [self.downloadButton.titleLabel sizeToFit];
            self.downloadButton.layer.borderColor = [UIColor_HexString colorFromHexString:@"#B7B7B7"].CGColor;
            [self.downloadButton setTitleColor:[UIColor_HexString colorFromHexString:@"#B7B7B7"] forState:UIControlStateNormal];
            self.downloadButton.enabled = NO;
            break;
        } else {
            self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.downloadButton.layer.borderWidth = 1;
            self.downloadButton.layer.cornerRadius = 6;
            self.downloadButton.layer.borderColor = [UIColor_HexString colorFromHexString:@"#3476D8"].CGColor;
            [self.downloadButton setTitle:@"FREE" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)segmentAction:(id)sender {
    
    if (self.segmentSelect.selectedSegmentIndex == 0) {
        [top10text removeFromSuperview];
        [swipeView1 removeFromSuperview];
        [titleView1 removeFromSuperview];
        [seeAllButton removeFromSuperview];
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
        [self addRelation];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

#pragma ---
#pragma tablview Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentSelect.selectedSegmentIndex == 0) {
        return 2;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentSelect.selectedSegmentIndex == 0 && indexPath.row == 0) {
        return 180;
    } else if (self.segmentSelect.selectedSegmentIndex == 0 && indexPath.row == 1) {
        return 230;
    }
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const informationIdentifier;
    
    
    InformationCell *cell = (InformationCell *)[tableView dequeueReusableCellWithIdentifier:informationIdentifier];
    
    if (self.segmentSelect.selectedSegmentIndex == 0) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:self options:nil];
        cell = [nib objectAtIndex:indexPath.row];
        
        cell.desText.text = [self.detailItem valueForKey:@"des"];
        
        cell.languageText.text = [self.detailItem valueForKey:@"language"];
        cell.categoryText.text = self.cateogryName;
        cell.publisherText.text = self.nameAuthor;
        cell.publishedText.text = [self.detailItem valueForKey:@"publisher"];
        cell.sizeText.text = [self.detailItem valueForKey:@"filesize"];
        cell.printLengthText.text = [[self.detailItem valueForKey:@"page"]stringValue];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}


- (IBAction)downloadAction:(id)sender {
    
    [self.downloadButton setFrame:CGRectMake(227,65,80, 26)];
    self.downloadButton.layer.borderWidth = 1;
    self.downloadButton.layer.borderColor = [UIColor_HexString colorFromHexString:@"#5CfAB9"].CGColor;
    self.downloadButton.layer.cornerRadius = 6;
    self.downloadButton.layer.masksToBounds = YES;
    self.downloadButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.downloadButton setTitle:@"GET BOOK" forState:UIControlStateNormal];
    [self.downloadButton setTitleColor:[UIColor_HexString colorFromHexString:@"#5CfAB9"] forState:UIControlStateNormal];
    [self.downloadButton addTarget:self action:@selector(addOrder) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)addOrder {
    
    self.downloadButton.layer.borderColor = [UIColor_HexString colorFromHexString:@"#B7B7B7"].CGColor;
    [self.downloadButton setTitleColor:[UIColor_HexString colorFromHexString:@"#B7B7B7"] forState:UIControlStateNormal];
    self.downloadButton.enabled = NO;
    
    BooksManager *book = [[BooksManager alloc]init];
    [book addBookToDownload:[self.detailItem valueForKey:@"bookname"]];
    [book writeToPhoto:[self.detailItem valueForKey:@"bookname"] image:[self.detailItem valueForKey:@"imagebook"] imageInSeeAll:nil];
    
    UIAlertView *aleartView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Book already add to your shelf" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [aleartView show];
    [self close:self];
    
}

#pragma swipView
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return self.bookDataRelation.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    if (!view)  {
        
        view = [[NSBundle mainBundle] loadNibNamed:@"StoreBookView" owner:self options:nil][0];
        
        
        // set bookname
        UILabel *bookName = (UILabel *)[view viewWithTag:101];
        bookName.text = [[self.bookDataRelation objectAtIndex:index] valueForKey:@"bookname"];
        bookName.adjustsFontSizeToFitWidth  = YES;
        
        // set author
        UILabel *author = (UILabel *)[view viewWithTag:102];
        author.text = self.nameAuthor;
        
        
        // set button to view detail
        UIButton *button = (UIButton *)[view viewWithTag:301];
        [button addTarget:self action:@selector(seebook:) forControlEvents:UIControlEventTouchUpInside];
        
        // set imagebook
        PFFile *userImageFile = [[self.bookDataRelation objectAtIndex:index]valueForKey:@"imagebook"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [button setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
        
        
    }
    return view;
}

#pragma -
#pragma Buttom Action

- (IBAction)seeAllRelated:(id)sender {
    
    SeeAllViewController *seeAll = [[SeeAllViewController alloc]initWithNibName:@"SeeAllViewController" bundle:nil];
    seeAll.titleName = self.nameAuthor;
    seeAll.bookData = self.bookDataRelation;
    seeAll.getAllAuthor = self.authorData;
    seeAll.getAllCategory = self.categoryData;
    
    [self.navigationController pushViewController:seeAll animated:YES];
    
}

- (IBAction)seebook:(id)sender {
    
    [self close:self];
    
    NSInteger index = [swipeView1 indexOfItemViewOrSubview:sender];
    
    NSArray *bookRelation = [self.bookDataRelation objectAtIndex:index];
    
    [self.delegate openRelationDataBook:self bookData:bookRelation authorName:[[self.bookDataRelation objectAtIndex:index]valueForKeyPath:@"authorId.objectId"]];
}



@end
