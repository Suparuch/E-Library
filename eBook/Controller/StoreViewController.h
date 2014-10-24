//
//  StoreViewController.h
//  eBook
//
//  Created by Suparuch Sriploy on 9/2/14.
//  Copyright (c) 2014 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBookViewController.h"
#import "iCarousel.h"
#import "PopupSearchTableViewController.h"

@interface StoreViewController : UIViewController <UIPopoverControllerDelegate,RecentSearchesDelegate , UISearchBarDelegate,relationDelegate>

@property (strong, nonatomic) DetailBookViewController *detailViewController;
@property (strong, nonatomic) NSArray *bookArray;

@end
