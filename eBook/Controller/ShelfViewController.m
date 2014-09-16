//
//  ShelfViewController.m
//  eBook
//
//  Created by Sittikorn on 9/4/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "ShelfViewController.h"
#import "BooksManager.h"
#import <Parse/Parse.h>
#import "ReaderViewController.h"
#import "UIColor+HexString.h"

@interface ShelfViewController () <ReaderViewControllerDelegate>

@property (strong, nonatomic) UIButton *buttonDownload;
@property (strong, nonatomic) NSArray *bookArray;
@property (strong, nonatomic) UIProgressView *progressView;
@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *rectArray;

@end

@implementation ShelfViewController

@synthesize rectArray;

-(BOOL)isLandScape{
    
    UIInterfaceOrientation ort =  [[UIApplication sharedApplication] statusBarOrientation];
    
    return UIInterfaceOrientationIsLandscape(ort);
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Shelf";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bookArray = [BooksManager getAllBookDidAdd];
    [self setShelf];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSArray *viewsToRemove = [self.mainBookView subviews];
    
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rectArray = [[NSMutableArray alloc] initWithCapacity:self.mainBookView.subviews.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Show Shlef

-(void)setShelf{
    
    CGFloat view_w = 275;
    CGFloat view_h = 340;
    CGFloat view_x = 5;
    CGFloat view_y = 50;
    
    if ([self.bookArray count]>3) {
        if ([self.bookArray count]/ 3 == 0){
            shelfNeed = ([self.bookArray count]/3);
        } else {
            shelfNeed = ([self.bookArray count]/3)+1;
        }
    }
    else
    {
        shelfNeed = 2;
    }
    
    for (int i = 0; i < [self.bookArray count] ; i++) {
        
        UIView *bookView = [[UIView alloc]initWithFrame:CGRectMake(view_x, view_y, view_w, view_h)];
        bookView.backgroundColor = [UIColor clearColor];
        
        UIImageView *bookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(23, 0, 175, 230)];
        PFFile *userImageFile = [[self.bookArray objectAtIndex:i] valueForKey:@"imagebook"];
        NSData *imageData = [userImageFile getData];
        bookImageView.image = [UIImage imageWithData:imageData];
        bookImageView.layer.borderWidth = 1;
        bookImageView.layer.masksToBounds = YES;
        bookImageView.layer.cornerRadius = 15.;
        
        UILabel *booknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(view_x - 20 ,view_y + 10, view_w -20, view_h +50)];
        booknameLabel.font = [UIFont systemFontOfSize:12];
        booknameLabel.text = [[self.bookArray objectAtIndex:i] valueForKey:@"bookname"];
        booknameLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.buttonDownload = [[UIButton alloc]init];
        self.buttonDownload.frame = CGRectMake(23, 0,175, 230);
        [self.buttonDownload setBackgroundColor:[UIColor redColor]];
        self.buttonDownload.tag = i;
        self.buttonDownload.layer.masksToBounds = YES;
        self.buttonDownload.layer.cornerRadius = 4;
        [self.buttonDownload addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [bookView addSubview:self.buttonDownload];
        [bookView addSubview:booknameLabel];
        [bookView addSubview:bookImageView];
        [self.mainBookView addSubview:bookView];
        [self moveBook];
    }
}

-(void)moveBook
{
    
    CGFloat view_w = 170;
    CGFloat view_h = 230;
    CGFloat view_x = 75;
    CGFloat view_y = 100;
    
    CGFloat bookMarginX = 230;
    CGFloat bookMarginY = 310;
    
    int bookIndex = 1;
    int shelfBarIndex = 1;
    NSInteger shelfBook;
    
    
    CGFloat shelfMarginY = 200;
    //CGFloat shelfX = 38;
    CGFloat shelfY = 200;
    //CGFloat shelfWidth = 693;
    CGFloat shelfHeight = 5;
    
    NSInteger totalShelf ;
    CGFloat pageHeight;
    
    shelfBook  = 3;
    
    if (([self.mainBookView.subviews count] % shelfBook)==0) {
        NSLog(@"in shelf =0  %u",[self.mainBookView.subviews count] % shelfBook);
        [self.scrollView setScrollEnabled:YES];
        
        totalShelf = ([self.mainBookView.subviews count]/shelfBook);
        
    }else{
        
        NSLog(@"in shelf =!0  %u",[self.mainBookView.subviews count] % shelfBook);
        totalShelf = ([self.mainBookView.subviews count]/shelfBook+1);
    }
    if (totalShelf <= 1) {
        totalShelf = 1;
        [self.scrollView setScrollEnabled:YES];
        pageHeight = 586;
    }
    else
    {
        pageHeight = shelfY + ((totalShelf -1)*shelfMarginY) + shelfHeight + 75;
    }
    
    [self.scrollView setFrame:CGRectMake(0, 0, 1536, 2048)];
    [self.scrollView setContentSize:CGSizeMake(320, pageHeight)];
    [self.mainBookView setFrame:CGRectMake(0, -78, 1536, pageHeight)];
    
    NSLog(@"mainBookView %f",self.mainBookView.frame.origin.y);
    
    [self ManageShelf:totalShelf];
    NSLog(@"subview %@",self.mainBookView.subviews);
    for (UIView *bookViewDetail in self.mainBookView.subviews) {
        
        if (bookIndex % (shelfBook+1) == 0) {
            shelfBarIndex++;
            bookIndex = 1;
        }
        CGFloat book_x = view_x + (bookMarginX * (bookIndex++ -1));
        CGFloat book_y = view_y + (bookMarginY * (shelfBarIndex -1));
        
        bookViewDetail.frame = CGRectMake(book_x, book_y, view_w, view_h);
        
        
        CGRect Rect = bookViewDetail.frame;
        [rectArray addObject:[NSValue valueWithCGRect:Rect]];
    }
    [self.scrollView scrollsToTop];
    
}
-(void)ManageShelf:(NSInteger)totalShowShelf
{
    for (NSInteger i=1; i <= shelfNeed; i++) {
        [self.scrollView viewWithTag:i].hidden = (i>totalShowShelf);
    }
}


#pragma Download


-(IBAction)download:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    
    NSInteger index = [rectArray count] - 1;
    for (id object in [rectArray reverseObjectEnumerator]) {
        if ([rectArray indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
            [rectArray removeObjectAtIndex:index];
        }
        index--;
    }
    
    CGRect myRect = [[rectArray objectAtIndex:i] CGRectValue];
    //NSLog(@"%@", NSStringFromCGRect(myRect));
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"order"];
    PFQuery *query = [relation query];
    [query whereKey:@"bookname" equalTo:[[self.bookArray objectAtIndex:i]valueForKey:@"bookname"]];
    
    NSArray *getBookData = [query findObjects];
    
    NSLog(@"getBookData %@",getBookData);
    
    PFFile *bookData = [[getBookData objectAtIndex:0] valueForKey:@"bookdata"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *filePath = [path stringByAppendingPathComponent:[[self.bookArray objectAtIndex:i]valueForKey:@"bookname"]];
    
    NSLog(@"filepath %@",path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExists) {
        
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        self.progressView.frame = CGRectMake(myRect.origin.x +40 ,myRect.origin.y + 200, myRect.size.width - 20, myRect.size.height -100);
        self.progressView.layer.borderWidth = 0.1;
        self.progressView.progress = 0.0;
        self.progressView.trackTintColor = [UIColor whiteColor];
        [self.progressView setProgressTintColor:[UIColor_HexString colorFromHexString:@"#87CEFA"]];
        [self.progressView setTransform:CGAffineTransformMakeScale(1.0, 2.0)];
        
        [self.mainBookView addSubview:self.progressView];
        
        [bookData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            
            if (!error) {
                [data writeToFile:filePath atomically:YES];
            }
            
        } progressBlock:^(int percentDone) {
            
            self.progressView.progress = (float) percentDone/100.0;
        }
         ];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self.view setUserInteractionEnabled:NO];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(setCustomProgress) userInfo:nil repeats:YES];
        
    } else {
        
        [self didClickOpenPDF:sender];
        
    }
}

-(void)setCustomProgress
{
    
    if(self.progressView.progress == 1.0)
        
    {
        
        [self.timer invalidate];
        self.timer = nil;
        [self.progressView removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        NSLog(@"DONE !!!");
    }
}

-(void)didClickOpenPDF:(id)sender {
    
    BOOL success;
    
    UIButton *button = (UIButton *)sender;
    NSInteger i = button.tag;
    
    NSString* filePathName = [[self.bookArray objectAtIndex:i]valueForKey:@"bookname"];
    
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
