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

/*
 *  Method : resetPassword
 *  Des : reset password with email
 *  param : email = email address
 *
 */
+ (void) resetPassword:(NSString *)email {
    [PFUser requestPasswordResetForEmailInBackground:email];
}


/*
 *  Method : newEmail
 *  Des : change email
 *  param : email = email address
 *          password = current password
 *          retye = re input password
 *
 */
+ (void) newEmail:(NSString *)email password:(NSString *)password reTypePassword:(NSString *)retype withDelegate:(id<UserDelegate>)delegate{
    if (![password isEqualToString:[PFUser currentUser].password] && ![password isEqualToString:retype]) {
        NSLog(@"Sorry Password is not correct");
        [delegate userdidChange:NO];
    } else if ([[PFUser user].username isEqualToString:email]){
        NSLog(@"Sorry new email already token");
        [delegate userdidChange:NO];
    } else {
        [[PFUser currentUser] setEmail:email];
        [[PFUser currentUser] saveInBackground];
        [delegate userdidChange:YES];
    }
}

/*
 *  Method : currentPassword
 *  Des : change password
 *  param : current = current password
 *          password = new password
 *          retye = re input new password
 *
 */
+ (void) currentPassword:(NSString *)current changePassword:(NSString *)password retype:(NSString *)retype withDelegate:(id<UserDelegate>)delegate{
    
    if (![password isEqualToString:retype]){
        NSLog(@"Password is not equl");
        [delegate userdidchangePassWord:NO];
    } else if ([PFUser logInWithUsername:[PFUser currentUser].username password:current] && [password isEqualToString:retype]){
        [PFUser currentUser].password = password;
        [[PFUser currentUser] saveInBackground];
        [delegate userdidchangePassWord:YES];
    } else {
        [delegate userdidchangePassWord:NO];
    }
}
@end
