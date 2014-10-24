//
//  SeeAllCell.m
//  eBook
//
//  Created by Sittikorn on 9/15/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "SeeAllCell.h"
#import "UIColor+HexString.h"
#import "DetailBookViewController.h"
#import "BooksManager.h"
#import "UIColor+HexString.h"

@implementation SeeAllCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bookNameLabel.adjustsFontSizeToFitWidth = YES;
}

- (IBAction)summitAction:(id)sender {
    
    [self.submit setFrame:CGRectMake(227,65,80, 40)];
    self.submit.layer.borderWidth = 1;
    self.submit.layer.borderColor = [UIColor_HexString colorFromHexString:@"#5CfAB9"].CGColor;
    self.submit.layer.cornerRadius = 6;
    self.submit.layer.masksToBounds = YES;
    self.submit.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.submit setTitle:@"GET BOOK" forState:UIControlStateNormal];
    [self.submit setTitleColor:[UIColor_HexString colorFromHexString:@"#5CfAB9"] forState:UIControlStateNormal];
    [self.submit.titleLabel sizeToFit];
    [self.submit addTarget:self action:@selector(addOrder) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addOrder {
    
    self.submit.layer.borderColor = [UIColor_HexString colorFromHexString:@"#B7B7B7"].CGColor;
    [self.submit setTitleColor:[UIColor_HexString colorFromHexString:@"#B7B7B7"] forState:UIControlStateNormal];
    self.submit.enabled = NO;
    
    BooksManager *book = [[BooksManager alloc]init];
    [book addBookToDownload:self.bookNameLabel.text];
    [book writeToPhoto:self.bookNameLabel.text image:nil imageInSeeAll:self.imageBook.image];
    
    UIAlertView *aleartView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Book already add to your shelf" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
    [aleartView show];
}

@end
