//
//  User.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "User.h"
#import <Parse/Parse.h>

@implementation User


/*
 *  Method : loginWithSystem
 *  Des : Login
 *  param : username = username
 *          password = password
 *
 */
+ (void) loginWithSystem :(NSString *)username withPassword:(NSString *)password withDelegate:(id<UserDelegate>)delegate{
    
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful login");
                                            // Callback - login successful
                                            if ([delegate respondsToSelector:@selector(userDidLogin:)]) {
                                                [delegate userDidLogin:YES];
                                            }
                                        } else {
                                            // The login failed. Check error to see why.'
                                            NSLog(@"login failed");
                                            
                                            // Callback - login failed
                                            if ([delegate respondsToSelector:@selector(userDidLogin:)]) {
                                                [delegate userDidLogin:NO];
                                            }
                                            
                                        }
                                    }];
    
}

/*
 *  Method : getUserData
 *  Des : get Current user data
 *
 */
+ (NSArray *)getUserData {
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    NSArray *userData = [query findObjects];
    
    NSLog(@"friend %@",userData);
    return userData;
}


@end
