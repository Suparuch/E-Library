//
//  PopupSearchTableViewController.h
//  eBook
//
//  Created by Sittikorn on 9/17/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupSearchTableViewController;

@protocol RecentSearchesDelegate

// sent when the user selects a row in the recent searches list
- (void)recentSearchesController:(PopupSearchTableViewController *)controller didSelectString:(NSString *)searchString;

@end

@interface PopupSearchTableViewController : UITableViewController 

@property (nonatomic, strong) NSArray *allBookbData;
@property (nonatomic, weak) id <RecentSearchesDelegate> delegate;

- (void)filterResultsUsingString:(NSString *)filterString;

@end
