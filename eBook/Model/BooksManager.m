//
//  BooksManager.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "BooksManager.h"
#import <Parse/Parse.h>

@implementation BooksManager

/*
 *  Method : searchBook
 *  Des : search book with bookname
 *
 */
+ (NSArray *)searchBook:(NSString *)bookname {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"bookname" containsString:bookname];
    NSArray *bookFound = [query findObjects];
    
    NSLog(@"bookFound %@",bookFound);
    return bookFound;
}

/*
 *  Method : searchBook
 *  Des : add book in db for prepare downloading
 *  param : select = bookname
 *
 */
+ (void)addBookToDownload:(NSString *)select {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"bookname" equalTo:select];
    NSArray *addBook = [query findObjects];
    
    PFObject *book = addBook.lastObject;
    
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"order"];
    [relation addObject:book]; // friendUser is a PFUser that represents the friend
    [[PFUser currentUser] saveInBackground];
}

/*
 *  Method : showBookDidAdd
 *  Des : show all book data did add
 *
 */
+ (NSArray *)getALlBookDidAdd {
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"order"];
    PFQuery *query = [relation query];
    
    NSArray *getAllBook = [query findObjects];
    NSLog(@"getAllBook %@",getAllBook);
    return getAllBook;
}

/*
 *  Method : download
 *  Des : download books to local store
 *  param : selected = bookname
 *
 */
+ (void)download:(NSString *)selected forDelegate:(id<BooksDelegate>)delegate{
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"order"];
    PFQuery *query = [relation query];
    [query whereKey:@"bookname" equalTo:selected];
    
    NSArray *getBookData = [query findObjects];
    NSLog(@"getBookData %@",getBookData);
    
    PFFile *bookData = [[getBookData objectAtIndex:0] valueForKey:@"bookdata"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *filePath = [path stringByAppendingPathComponent:selected];
    
    NSLog(@"filepath %@",filePath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
    }
    [bookData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [data writeToFile:filePath atomically:YES];
            [delegate booksDownloadComplete:YES];
        }
    } progressBlock:^(int percentDone) {
        if ([delegate respondsToSelector:@selector(booksDownloadProgress:)]) {
            [delegate booksDownloadProgress:percentDone];
        }
        
    }];
}

/*
 *  Method : saveReview
 *  Des : save review to DB
 *  param : text = text review
 *
 */
+(void)saveReview:(NSString *)text {
    
}

@end
