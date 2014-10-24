//
//  ShelfCell.h
//  eBook
//
//  Created by Sittikorn on 9/16/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShelfCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *bookname;

@end
