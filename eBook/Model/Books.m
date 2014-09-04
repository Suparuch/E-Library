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
    NSArray *bookData = [query findObjects];

    
    NSMutableArray *dataBook = [[NSMutableArray alloc]initWithCapacity:bookData.count];
    
    for (int i = 0; i < bookData.count; i++) {
        NSDictionary *bookArray =  @{ @"description": @"Top View",
                                    @"articles": @[
                                            @{@"objectId" : [[bookData objectAtIndex:i]valueForKey:@"objectId"]
                                              ,@"author" : [[bookData objectAtIndex:i]valueForKey:@"authorname"]
                                              ,@"bookdata" : [[bookData objectAtIndex:i]valueForKey:@"bookdata"]
                                              ,@"title" : [[bookData objectAtIndex:i]valueForKey:@"bookname"]
                                              ,@"categoryid" : [[bookData objectAtIndex:i]valueForKey:@"categoryId"]
                                              ,@"des" : [[bookData objectAtIndex:i]valueForKey:@"des"]
                                              ,@"size" : [[bookData objectAtIndex:i]valueForKey:@"filesize"]
                                              ,@"image" : [[bookData objectAtIndex:i]valueForKey:@"imagebook"]
                                              ,@"page" : [[bookData objectAtIndex:i]valueForKey:@"page"]
                                              ,@"rating" : [[bookData objectAtIndex:i]valueForKey:@"rating"]
                                              ,@"ratingcount" : [[bookData objectAtIndex:i]valueForKey:@"ratingcount"]
                                              ,@"type" : [[bookData objectAtIndex:i]valueForKey:@"type"]
                                              ,@"publisher" : [[bookData objectAtIndex:i]valueForKey:@"publisher"]
                                              ,@"downloadcount" : [[bookData objectAtIndex:i]valueForKey:@"downloadcount"]}
                                            ]};
        [dataBook addObject:bookArray];
    }
    
    //NSLog(@"dataBook %@",dataBook);
    
    return dataBook;
}

@end
