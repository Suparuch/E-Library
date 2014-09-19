//
//  BooksManager.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "BooksManager.h"
#import "User.h"

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
 *  Des : search book with authorname
 *  parum : author : authorname
 *
 */
+ (NSArray *)searchBookWithAuthor:(NSString *)author {
    
    PFQuery *autherObjectId = [PFQuery queryWithClassName:@"Publisher"];
    [autherObjectId whereKey:@"name" equalTo:author];
    
    PFQuery *bookname = [PFQuery queryWithClassName:@"Books"];
    [bookname whereKey:@"authorname" matchesQuery:autherObjectId];
    
    NSArray *bookFound = [bookname findObjects];
    
    NSLog(@"bookFound %@",bookFound);
    
    return bookFound;
}

/*
 *  Method : searchBook
 *  Des : add book in db for prepare downloading
 *  param : select = bookname
 *
 */
- (void)addBookToDownload:(NSString *)select {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"bookname" equalTo:select];
    [query findObjectsInBackgroundWithBlock:^(NSArray *addBook, NSError *error) {
        
        PFObject *book = addBook.lastObject;
        [book incrementKey:@"downloadcount"];
        [book saveInBackground];
        
        PFRelation *relation = [[PFUser currentUser] objectForKey:@"order"];
        [relation addObject:book]; // friendUser is a PFUser that represents the friend
        [[PFUser currentUser] saveInBackground];
    }];
}

/*
 *  Method : writeToPhoto
 *  Des : save photo to local db
 *  param : bookname = bookname
 *          image = image
 *
 */
-(void) writeToPhoto:(NSString *)bookname image:(PFFile *)image imageInSeeAll:(UIImage *)imageSeeAll {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *str= [NSString stringWithFormat:@"%@.png",bookname];
    NSString *filePath = [path stringByAppendingPathComponent:str];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSLog(@"filePath %@",filePath);
    if (![fileManager fileExistsAtPath:path])
    {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExists) {
        if (image != nil) {
            PFFile *userImageFile = image;
            NSData *imageData = [userImageFile getData];
            [imageData writeToFile:filePath atomically:YES];
        } else {
            NSData *imageData = UIImagePNGRepresentation(imageSeeAll);
            [imageData writeToFile:filePath atomically:YES];
        }
    }
}

/*
 *  Method : retriveToPhoto
 *  Des : display photo to local db
 *  param : bookname = bookname
 *
 */
+(UIImage *)retriveAllPhoto:(NSString *)bookname {
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[PFUser currentUser].username];
    NSString *str= [NSString stringWithFormat:@"%@.png",bookname];
    NSString *filePath = [path stringByAppendingPathComponent:str];
    
    UIImage *image1=[UIImage imageWithContentsOfFile:filePath];
    
    return image1;
}

/*
 *  Method : showBookDidAdd
 *  Des : show all book data did add
 *
 */
+ (NSArray *)getAllBookDidAdd {
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"order"];
    PFQuery *query = [relation query];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    NSArray *getAllBook = [query findObjects];
    
    return getAllBook;
}

/*
 *  Method : saveReview
 *  Des : save review to DB
 *  param : text = text review
 *
 */
+(void)saveReview:(NSString *)text withBookname:(NSString *)bookId{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *queryReview, NSError *error) {
        
        NSLog(@"queryRating %@",queryReview);
        
        PFObject *Review = [PFObject objectWithClassName:@"Review"];
        Review[@"userId"] = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[PFUser currentUser].objectId];
        Review[@"bookId"] = [PFObject objectWithoutDataWithClassName:@"Books" objectId:bookId];
        Review[@"comment"] = text;
        
        [Review saveInBackground];
    }];
}

/*
 *  Method : getReview
 *  Des : get review from db
 *  param : bookId = objectId
 *
 */
+(NSArray *)getReview:(NSString *)bookId {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    NSArray *queryReview = [query findObjects];
    
    return queryReview;
}

/*
 *  Method : saveRating
 *  Des : save rating to DB
 *  param : rating = rating
 *          bookname = bookname
 *
 */
+(void)saveRating:(NSInteger)rating withName:(NSString *)bookname{
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"bookname" equalTo:bookname];
    [query findObjectsInBackgroundWithBlock:^(NSArray *queryRating, NSError *error) {
        
        //NSLog(@"queryRating %@",queryRating);
        
        NSInteger defaultRating = [[[queryRating objectAtIndex:0] valueForKey:@"rating"]integerValue];
        NSInteger resultRating =  defaultRating+rating;
        
        [query getObjectInBackgroundWithId:[[queryRating objectAtIndex:0] valueForKey:@"objectId"] block:^(PFObject *save, NSError *error) {
            
            save[@"rating"] = [NSNumber numberWithInt:resultRating];
            [save incrementKey:@"ratingcount"];
            [save saveInBackground];
            
        }];
    }];
}

/*
 *  Method : getRating
 *  Des : get rating from db
 *  param : bookname = bookname
 *
 */
+(NSInteger)getRating:(NSString *)bookname {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Books"];
    [query whereKey:@"bookname" equalTo:bookname];
    NSArray *queryRating = [query findObjects];
    
    NSLog(@"queryRating %@",queryRating);
    
    NSInteger ratingCount = [[[queryRating objectAtIndex:0]valueForKey:@"ratingcount"]integerValue];
    NSInteger allRating = [[[queryRating objectAtIndex:0]valueForKey:@"rating"]integerValue];
    
    NSInteger average = (ratingCount * 5)/allRating;
    
    NSLog(@"average %ld",(long)average);
    return average;
}

@end
