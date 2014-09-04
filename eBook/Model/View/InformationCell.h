//
//  InformationCell.h
//  eBook
//
//  Created by Sittikorn on 9/4/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *desText;

@property (strong, nonatomic) IBOutlet UILabel *languageText;
@property (strong, nonatomic) IBOutlet UILabel *categoryText;
@property (strong, nonatomic) IBOutlet UILabel *publisherText;
@property (strong, nonatomic) IBOutlet UILabel *publishedText;
@property (strong, nonatomic) IBOutlet UILabel *sizeText;
@property (strong, nonatomic) IBOutlet UILabel *printLengthText;

@end
