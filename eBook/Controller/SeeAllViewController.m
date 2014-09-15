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

@interface SeeAllViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView *myCollectionView;
@end

@implementation SeeAllViewController

@synthesize myCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeeAllCell *cell = (SeeAllCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.bookNameLabel.text = @"เมื่อวาน";
    cell.authorLabel.text = @"ไปไหน";
    cell.imageBook.image = [UIImage imageNamed:@"page.png"];
    [cell.submit setTitle:@"FREE" forState:UIControlStateNormal];
    cell.datePublishLabel.text = @"January 2014";
    
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
