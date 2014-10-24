//
//  problem.h
//  RedCross
//
//  Created by Sittikorn on 8/19/2557 BE.
//  Copyright (c) 2557 Suparuch Sriploy. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ProblemDelegate <NSObject>
@optional

- (void) problemDidSend:(BOOL)send;

@end

@interface problem : NSObject

+ (void) text:(NSString *)text withDelegate:(id<ProblemDelegate>)delegate;

@end
