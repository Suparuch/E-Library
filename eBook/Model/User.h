//
//  User.h
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserDelegate <NSObject>
@optional

- (void) userDidLogin:(BOOL)loggedIn;
- (void) userdidChange:(BOOL)didChange;
- (void) userdidchangePassWord:(BOOL)success;

@end

@interface User : NSObject

+ (NSArray *)getUserData;
+ (void) loginWithSystem :(NSString *)email withPassword:(NSString *)password withDelegate:(id<UserDelegate>)delegate;
+ (void) resetPassword:(NSString *)email;
+ (void) newEmail:(NSString *)email password:(NSString *)password reTypePassword:(NSString *)retype withDelegate:(id<UserDelegate>)delegate;
+ (void) currentPassword:(NSString *)current changePassword:(NSString *)password retype:(NSString *)retype withDelegate:(id<UserDelegate>)delegate;

@end
