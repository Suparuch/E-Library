//
//  ShelfViewController.h
//  eBook
//
//  Created by Sittikorn on 9/4/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShelfViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *mainBookView;


@end
