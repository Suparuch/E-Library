//
//  CategoryBooks.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "CategoryBooks.h"
#import <Parse/Parse.h>

@implementation CategoryBooks

/*
 *  Method : getAllCategory
 *  Des : get Category
 *
 */
+(NSArray *)getAllCategory {
    PFQuery *query = [PFQuery queryWithClassName:@"Category"];
    
    
    NSArray *allCategory = [query findObjects];
    
    return allCategory;
}



@end
