//
//  BooksManager.h
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface BooksManager : NSObject

+ (NSArray *)searchBook:(NSString *)bookname;
+ (NSArray *)searchBookWithAuthor:(NSString *)author;
+ (NSArray *)searchBookWithCategory:(NSString *)category;
+ (NSArray *)getAllBookDidAdd;
- (void)addBookToDownload:(NSString *)select;
- (void) writeToPhoto:(NSString *)bookname image:(PFFile *)image;
+ (void)saveRating:(NSInteger)rating withName:(NSString *)bookname;
+ (NSInteger)getRating:(NSString *)bookname;
+ (NSArray *)getReview:(NSString *)bookId;
+ (void)saveReview:(NSString *)text withBookname:(NSString *)bookname;
+ (UIImage *)retriveAllPhoto:(NSString *)bookname;
@end
