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

@interface ShelfViewController ()

@property (strong, nonatomic) NSArray *bookArray;

@end

@implementation ShelfViewController
{
    NSMutableArray *rectArray;
}

-(BOOL)isLandScape{
    
    UIInterfaceOrientation ort =  [[UIApplication sharedApplication] statusBarOrientation];
    
    return UIInterfaceOrientationIsLandscape(ort);
}


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Book Shelf";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.bookArray = [BooksManager getAllBookDidAdd];
    self.bookArray = [NSArray arrayWithObjects:@"1.png",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"1.png",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"1.png",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"1.png",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",nil];
    
    [self setShelf];
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
    
    for (UIView *view in self.mainBookView.subviews)
    {
        if (![view isKindOfClass:[UIImageView class]])
            [view removeFromSuperview];
    }
    for (NSString *book in self.bookArray) {
        
        NSString *bookImagePath = book;
        //NSLog(@"bookImagePath %@", book);
        
        
        UIView *bookView = [[UIView alloc]initWithFrame:CGRectMake(view_x, view_y, view_w, view_h)];
        bookView.backgroundColor = [UIColor clearColor];
        
        UIImageView *bookImageView = [[UIImageView alloc]initWithFrame:CGRectMake(23, 0, 175, 230)];
        
        bookImageView.image = [UIImage imageNamed:bookImagePath];
        
        [bookView addSubview:bookImageView];
        
        [self.mainBookView addSubview:bookView];
        [self moveBook];
    }
}

-(void)moveBook{
    
    // iPhone
    CGFloat view_w = 170;
    CGFloat view_h = 200;
    CGFloat view_x = 40;
    CGFloat view_y = 90;
    
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
    
    
    int totalShelf ;
    CGFloat pageHeight;
    
    if ([self isLandScape]) {
        
        shelfBook =5;
        // bookMarginX = 190;
        // bookMarginY = 200;
        if (([self.mainBookView.subviews count] % shelfBook)==0) {
//            NSLog(@"in shelf =0  %lu",[self.mainBookView.subviews count] % shelfBook);
            totalShelf = ([self.mainBookView.subviews count] / shelfBook);
            
        }else{
//            NSLog(@"in shelf =!0  %lu",[self.mainBookView.subviews count] % shelfBook);
            totalShelf = ([self.mainBookView.subviews count]/shelfBook + 1);
        }
        //  totalShelf = ([self.mainBookView.subviews count]/shelfBook)+1;
        if (totalShelf <= 4) {
            totalShelf = 4;
            [self.scrollView setScrollEnabled:YES];
            pageHeight = 748;
        }
        else
        {
            pageHeight = shelfY + ((totalShelf -1)*shelfMarginY) + shelfHeight + 20;
        }
        [self.mainBookView setFrame:CGRectMake(40, self.mainBookView.frame.origin.y, 1024, pageHeight)];
        
        [self.scrollView setContentSize:CGSizeMake(1024, pageHeight)];
    }
    
    else
    {
        shelfBook  = 3;
        //bookMarginX = 100;
        // bookMarginY = 250;
        if (([self.mainBookView.subviews count] % shelfBook)==0) {
//            NSLog(@"in shelf =0  %d",[self.mainBookView.subviews count] % shelfBook);
            [self.scrollView setScrollEnabled:YES];
            
            totalShelf = ([self.mainBookView.subviews count]/shelfBook);
            
        }else{
//            NSLog(@"in shelf =!0  %d",[self.mainBookView.subviews count] % shelfBook);
            totalShelf = ([self.mainBookView.subviews count]/shelfBook+1);
        }
        // totalShelf = ([self.mainBookView.subviews count]/shelfBook)+1;
        if (totalShelf <= 3) {
            totalShelf = 3;
            [self.scrollView setScrollEnabled:YES];
            pageHeight = 586;
        }
        else
        {
            pageHeight = shelfY + ((totalShelf -1)*shelfMarginY) + shelfHeight + 20;
        }
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height < 500){
            [self.scrollView setFrame:CGRectMake(0, 76, 768, 1024)];
            
        }
        else{
            [self.scrollView setFrame:CGRectMake(0, 76, 768, 1024)];
            
        }
        
        [self.scrollView setContentSize:CGSizeMake(320, pageHeight)];
        [self.mainBookView setFrame:CGRectMake(-5, -145, 320, pageHeight)];
//        NSLog(@"mainBookView %f",self.mainBookView.frame.origin.y );
    }
    
    
    for (UIView *bookView in self.mainBookView.subviews) {
        
        if (bookIndex % (shelfBook+1) == 0) {
            shelfBarIndex++;
            bookIndex = 1;
        }
        CGFloat book_x = view_x + (bookMarginX * (bookIndex++-1));
        CGFloat book_y = view_y + (bookMarginY * (shelfBarIndex -1));
        
        bookView.frame = CGRectMake(book_x, book_y, view_w, view_h);
    }
    
    [self.scrollView scrollsToTop];
    
}

@end
