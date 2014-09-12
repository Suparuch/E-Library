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

@interface DetailBookViewController () <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *dataView;
@property (strong, nonatomic) IBOutlet UIImageView *imageVIew;
@property (strong, nonatomic) IBOutlet UILabel *bookName;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UILabel *publishName;
@property (strong, nonatomic) IBOutlet UILabel *numberPage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentSelect;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;

- (IBAction)segmentAction:(id)sender;
- (IBAction)downloadAction:(id)sender;

@end

@implementation DetailBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBackground];
    //[self createUI];
    self.segmentSelect.selectedSegmentIndex = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InformationCell" bundle:nil] forCellReuseIdentifier:@"informationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReviewCell" bundle:nil] forCellReuseIdentifier:@"reviewCell"];
    
    NSLog(@"bookData %@",self.detailItem);
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
    
    PFFile *userImageFile = self.detailItem[@"image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageVIew.image = image;
        }
    }];
    
    [self.imageVIew layer].borderWidth = 1;
    self.bookName.text = self.detailItem[@"title"];
    self.authorName.text = self.detailItem[@"author"];
    self.publishName.text = self.detailItem[@"publisher"];
    self.numberPage.text = [self.detailItem[@"page"]stringValue];
    
    NSArray *bookAdd = [BooksManager getAllBookDidAdd];
    
    for (int i = 0; i < bookAdd.count; i++) {
        
        NSString *bookname = [[bookAdd objectAtIndex:i]valueForKey:@"bookname"];
        
        if ([[self.detailItem objectForKey:@"title"] isEqualToString:bookname]) {
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
            self.downloadButton.layer.borderColor = [UIColor_HexString colorFromHexString:@"#B7B7B7"].CGColor;
            [self.downloadButton setTitle:@"FREE" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)segmentAction:(id)sender {
    
    [self.tableView reloadData];
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
    } else if (self.segmentSelect.selectedSegmentIndex == 1) {
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
    } else if (self.segmentSelect.selectedSegmentIndex == 1 && indexPath.row == 0) {
        return 190;
    } else if (self.segmentSelect.selectedSegmentIndex == 1 && indexPath.row == 1) {
        return 90;
    }
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *const informationIdentifier;
    static NSString *const reviewIdentifier;
    
    InformationCell *cell = (InformationCell *)[tableView dequeueReusableCellWithIdentifier:informationIdentifier];
    
    if (self.segmentSelect.selectedSegmentIndex == 0) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InformationCell" owner:self options:nil];
        cell = [nib objectAtIndex:indexPath.row];
        
        cell.desText.text = self.detailItem[@"des"];
        
        cell.languageText.text = @"Thai";
        cell.categoryText.text = @"Programming";
        cell.publisherText.text = self.detailItem[@"author"];
        cell.publishedText.text = self.detailItem[@"publisher"];
        cell.sizeText.text = self.detailItem[@"size"];
        cell.printLengthText.text = [self.detailItem[@"page"]stringValue];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (self.segmentSelect.selectedSegmentIndex == 1) {
        
        ReviewCell *cell1 = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:reviewIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReviewCell" owner:self options:nil];
        cell1 = [nib objectAtIndex:indexPath.row];
        
        
        cell1.allRating.text = [self.detailItem[@"rating"]stringValue];
        [cell1.writeAction addTarget:self action:@selector(writeReview:) forControlEvents:UIControlEventTouchUpInside];
        
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell1;
    }
    
    return cell;
}

-(IBAction)writeReview:(id)sender {
    NSLog(@"log");
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
    [BooksManager addBookToDownload:self.detailItem[@"title"]];
    
    
    UIAlertView *aleartView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Book already add to your shelf" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [aleartView show];
    
}
@end
