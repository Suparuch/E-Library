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

@implementation SeeAllCell

- (void)awakeFromNib {
    // Initialization code
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
    [self.submit addTarget:self action:@selector(addOrder:) forControlEvents:UIControlEventTouchUpInside];
}

@end
