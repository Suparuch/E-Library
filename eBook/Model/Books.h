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
+(NSArray *)getTop10Book;
+(NSArray *)getRelationBook:(NSString *)authorname;

@end
