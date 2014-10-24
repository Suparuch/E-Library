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
 *  Method : getAuthorData
 *  Des : get author data
 *
 */
+(NSArray *)getAuthorData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Publisher"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    NSArray *authorData = [query findObjects];
    
    return authorData;
}

/*
 *  Method : getTop10Book
 *  Des : sort book with downloadcount
 *  param : data = AllBook
 *
 */
+(NSArray *)getTop10Book:(NSArray *)data {
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"downloadcount" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *bookData = [data sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return bookData;
}


/*
 *  Method : newRelease
 *  Des : sort book with createAt
 *  param : data = AllBook
 *
 */
+(NSArray *)getNewRelease:(NSArray *)data {
    
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *bookData = [data sortedArrayUsingDescriptors:sortDescriptors];
    
    return bookData;
}

/*
 *  Method : getRelationBook
 *  Des : get All with author relation
 *  param : data = AllBook
 *          authorname = Author objectId
 *
 */
+(NSArray *)getRelationBook:(NSArray *)data authorname:(NSString *)authorname {
    
    NSMutableArray *bookData = [[NSMutableArray alloc]initWithCapacity:data.count];
    
    for (int i = 0; i < data.count; i++) {
        if ([[[data objectAtIndex:i] valueForKeyPath:@"authorId.objectId"] isEqualToString:authorname]) {
            [bookData addObject:[data objectAtIndex:i]];
        }
    }
    return bookData;
}


@end

