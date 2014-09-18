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

- (void)openRelationDataBook:(DetailBookViewController *)controller bookData:(NSArray *)bookData authorName:(NSString *)objectId;

@end

@interface DetailBookViewController : UIViewController

@property (nonatomic, weak) id <relationDelegate> delegate;

@property (strong, nonatomic) NSArray *detailItem;
@property (strong, nonatomic) NSString *cateogryName;

@property (strong, nonatomic) NSArray *bookDataRelation;
@property (strong, nonatomic) NSString *nameAuthor;

@property (strong, nonatomic) NSArray *authorData;
@property (strong, nonatomic) NSArray *categoryData;
@end
