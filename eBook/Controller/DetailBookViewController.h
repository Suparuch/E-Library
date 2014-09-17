//
//  DetailBookViewController.h
//  eBook
//
//  Created by Sittikorn on 9/3/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailBookViewController;

@protocol relationDelegate <NSObject>

- (void)openRelationDataBook:(DetailBookViewController *)controller bookData:(NSArray *)bookData;

@end

@interface DetailBookViewController : UIViewController

@property (nonatomic, weak) id <relationDelegate> delegate;

@property (strong, nonatomic) NSArray *detailItem;
@property (strong, nonatomic) NSString *cateogryName;

@property (strong, nonatomic) NSArray *authordata;

@end
