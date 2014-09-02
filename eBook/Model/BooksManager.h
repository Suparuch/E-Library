//
//  BooksManager.h
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BooksDelegate <NSObject>
@optional

- (void) booksDownloadProgress:(short)progress;
- (void) booksDownloadComplete:(BOOL)success;

@end

@interface BooksManager : NSObject

+ (NSArray *)searchBook:(NSString *)bookname;
+ (void)addBookToDownload:(NSString *)select;
+ (NSArray *)getALlBookDidAdd;
+ (void)download:(NSString *)selected forDelegate:(id<BooksDelegate>)delegate;
+(void)saveRating:(NSInteger)rating withName:(NSString *)bookname;

@end
