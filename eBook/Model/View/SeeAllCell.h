//
//  SeeAllCell.h
//  eBook
//
//  Created by Sittikorn on 9/15/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeeAllCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageBook;
@property (strong, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *datePublishLabel;
@property (strong, nonatomic) IBOutlet UIButton *submit;

- (IBAction)summitAction:(id)sender;

@end
