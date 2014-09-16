//
//  SeeAllViewController.m
//  eBook
//
//  Created by Sittikorn on 9/15/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "SeeAllViewController.h"
#import "SeeAllCell.h"
#import "DetailBookViewController.h"
#import <Parse/Parse.h>
#import "BooksManager.h"
#import "UIColor+HexString.h"

@interface SeeAllViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView *myCollectionView;
@end

@implementation SeeAllViewController

@synthesize myCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.titleName;
    NSLog(@"bookData %@",self.bookData);
    
    [self addCollectionView];
    
    UINib *nib = [UINib nibWithNibName:@"SeeAllCell" bundle:nil];
    [myCollectionView registerNib:nib forCellWithReuseIdentifier:@"cellIdentifier"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCollectionView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    myCollectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [myCollectionView setDataSource:self];
    [myCollectionView setDelegate:self];
    
    [myCollectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:myCollectionView];
    
}

#pragma collectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bookData.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeeAllCell *cell = (SeeAllCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.bookNameLabel.text = [[self.bookData objectAtIndex:indexPath.row]valueForKey:@"bookname"];
    cell.authorLabel.text = [[self.bookData objectAtIndex:indexPath.row]valueForKey:@"authorname"];
    cell.datePublishLabel.text = [[self.bookData objectAtIndex:indexPath.row]valueForKey:@"publisher"];
    
    // set imagebook
    PFFile *userImageFile = [[self.bookData objectAtIndex:indexPath.row]valueForKey:@"imagebook"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageBook.image = image;
        }
    }];
    
    
    [cell.submit setTitle:@"FREE" forState:UIControlStateNormal];
    
    
    NSArray *bookAdd = [BooksManager getAllBookDidAdd];
    for (int i = 0; i < bookAdd.count; i++) {
        NSString *bookname = [[bookAdd objectAtIndex:i]valueForKey:@"bookname"];
        
        if ([[[self.bookData objectAtIndex:indexPath.row]valueForKey:@"bookname"] isEqualToString:bookname]) {
            cell.submit.layer.borderWidth = 1;
            cell.submit.layer.cornerRadius = 6;
            cell.submit.layer.masksToBounds = YES;
            cell.submit.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.submit setTitle:@"GOT BOOK" forState:UIControlStateNormal];
            [cell.submit.titleLabel sizeToFit];
            cell.submit.layer.borderColor = [UIColor_HexString colorFromHexString:@"#B7B7B7"].CGColor;
            [cell.submit setTitleColor:[UIColor_HexString colorFromHexString:@"#B7B7B7"] forState:UIControlStateNormal];
            cell.submit.enabled = NO;
            break;
        } else {
            cell.submit.titleLabel.textAlignment = NSTextAlignmentCenter;
            cell.submit.layer.borderWidth = 1;
            cell.submit.layer.cornerRadius = 6;
            cell.submit.layer.borderColor = [UIColor_HexString colorFromHexString:@"#3476D8"].CGColor;
            [cell.submit setTitle:@"FREE" forState:UIControlStateNormal];
        }
    }
    
    
    cell.backgroundColor= [[UIColor greenColor]colorWithAlphaComponent:0.1];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(368, 120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
@end
