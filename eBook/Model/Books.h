//
//  Books.h
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Books : NSObject

+(NSArray *)getAllBook;
+(NSArray *)getRelationBook:(NSString *)authorname;
+(NSArray *)getTop10Book:(NSArray *)data;
+(NSArray *)getNewRelease:(NSArray *)data;
+(NSArray *)getBookImageHighlight:(NSArray *)data;

@end
