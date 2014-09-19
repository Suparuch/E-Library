//
//  ShelfViewController.m
//  eBook
//
//  Created by Sittikorn on 9/16/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "ShelfViewController.h"
#import "ShelfCell.h"
#import <Parse/Parse.h>
#import "BooksManager.h"
#import "ReaderViewController.h"
#import "UIColor+HexString.h"

@interface ShelfViewController () <UICollectionViewDataSource,UICollectionViewDelegate,ReaderViewControllerDelegate>

@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (nonatomic,strong) NSArray *getAllBookAdd;

@end

@implementation ShelfViewController

@synthesize myCollectionView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Shelf";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCollectionView];
    
    UINib *nib = [UINib nibWithNibName:@"ShelfCell" bundle:nil];
    [myCollectionView registerNib:nib forCellWithReuseIdentifier:@"cellIdentifier"];
}

- (void)viewDidAppear:(BOOL)animated {
    self.getAllBookAdd = [BooksManager getAllBookDidAdd];
    [self.myCollectionView reloadData];
    [super viewDidAppear:animated];
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
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self. refreshControl addTarget:self action:@selector(startRefresh:) forControlEvents:UIControlEventValueChanged];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView addSubview:self.refreshControl];
    
    [self.view addSubview:myCollectionView];
}


#pragma --
#pragma UICollectionView

- (IBAction)startRefresh:(id)sender {
    
    self.getAllBookAdd = [BooksManager getAllBookDidAdd];
    [myCollectionView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.getAllBookAdd.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShelfCell *cell = (ShelfCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    UIImage *image = [BooksManager retriveAllPhoto:[[self.getAllBookAdd objectAtIndex:indexPath.row] valueForKey:@"bookname"]];
    
    if (image == nil) {
        BooksManager *book = [[BooksManager alloc]init];
        [book writeToPhoto:[[self.getAllBookAdd objectAtIndex:indexPath.row] valueForKey:@"bookname"] image:[[self.getAllBookAdd objectAtIndex:indexPath.row] valueForKey:@"imagebook"] imageInSeeAll:nil];
        
        cell.image.image = [BooksManager retriveAllPhoto:[[self.getAllBookAdd objectAtIndex:indexPath.row] valueForKey:@"bookname"]];
    } else {
        cell.image.image = image;
    }
    
    cell.bookname.text =[[self.getAllBookAdd objectAtIndex:indexPath.row] valueForKey:@"bookname"];
    cell.image.layer.borderWidth = 1;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.cornerRadius = 6;
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(175, 280);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(40, 40, 80, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"order"];
    PFQuery *query = [relation query];
    [query whereKey:@"bookname" equalTo:[[self.getAllBookAdd objectAtIndex:indexPath.row]valueForKey:@"bookname"]];
    
    NSArray *getBookData = [query findObjects];
    
    PFFile *bookData = [[getBookData objectAtIndex:0] valueForKey:@"bookdata"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *filePath = [path stringByAppendingPathComponent:[[self.getAllBookAdd objectAtIndex:indexPath.row]valueForKey:@"bookname"]];
    
    NSLog(@"filepath %@",path);
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExists) {
        
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectMake(selectedCell.frame.origin.x + 10, selectedCell.frame.origin.y + 200, selectedCell.frame.size.width - 20, selectedCell.frame.size.height - 100);
        self.progressView.layer.borderWidth = 0.1;
        self.progressView.progress = 0.0;
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.progressView setProgressTintColor:[UIColor_HexString colorFromHexString:@"#87CEFA"]];
        [self.progressView setTransform:CGAffineTransformMakeScale(1.0, 2.0)];
        
        [selectedCell setUserInteractionEnabled:NO];
        
        [self.myCollectionView addSubview:self.progressView];
        
        [bookData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                [data writeToFile:filePath atomically:YES];
                [selectedCell setUserInteractionEnabled:YES];
            }
            
        } progressBlock:^(int percentDone) {
            
            self.progressView.progress = (float) percentDone/100.0;
        }
         ];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(setCustomProgress) userInfo:nil repeats:YES];
        
    } else {
        
        [self didClickOpenPDF:indexPath.row];
        
    }
}

-(void)setCustomProgress
{
    if(self.progressView.progress == 1.0)
    {
        [self.timer invalidate];
        self.timer = nil;
        [self.progressView removeFromSuperview];
        
        NSLog(@"DONE !!!");
    }
}

-(void)didClickOpenPDF:(NSInteger *)i {
    
    BOOL success;
    
    NSString* filePathName = [[self.getAllBookAdd objectAtIndex:i]valueForKey:@"bookname"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *filePath = [dataPath stringByAppendingPathComponent:filePathName];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:filePath];
    if (success) {
        NSLog(@"Open : %@",filePathName);
    }
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:nil];
    
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self.navigationController presentViewController:readerViewController animated:YES completion:nil];
    }
}

@end
