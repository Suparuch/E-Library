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

@interface StoreViewController : UIViewController <iCarouselDataSource,iCarouselDelegate>

@property (strong, nonatomic) DetailBookViewController *detailViewController;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;

@end
