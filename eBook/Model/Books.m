//
//  Books.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "Books.h"
#import <Parse/Parse.h>

@implementation Books

/*
 *  Method : getAllBook
 *  Des : get Book Data
 *
 */
+(NSArray *)getAllBook {
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    NSArray *allBooks = [query findObjects];
    
    NSLog(@"allBookData : %@",allBooks);
    return allBooks;
}



@end
