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
 *  Des : get Books Data
 *
 */
+(NSArray *)getAllBook {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    NSArray *bookData = [query findObjects];
    
    //NSLog(@"dataBook %@",dataBook);
    
    return bookData;
}

/*
 *  Method : getTop10Book
 *  Des : get top 10 download books
 *
 */
+(NSArray *)getTop10Book {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query orderByDescending:@"downloadcount"];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    NSArray *bookData = [query findObjects];
    
    NSLog(@"dataBook %@",bookData);
    
    return bookData;
}

/*
 *  Method : getRelationBook
 *  Des : get book relation with name
 *  parum : authorname = objectId
 *
 */
+(NSArray *)getRelationBook:(NSString *)authorname {
    
    PFQuery *book = [PFQuery queryWithClassName:@"Books"];
    [book includeKey:@"authorname.ojbectId"];
    
    book.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    NSArray *bookData = [book findObjects];
    
    NSLog(@"dataBook %@",bookData);
    
    return bookData;
}


@end

