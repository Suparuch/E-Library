//
//  problem.m
//  RedCross
//
//  Created by Sittikorn on 8/19/2557 BE.
//  Copyright (c) 2557 Suparuch Sriploy. All rights reserved.
//

#import "problem.h"
#import <Parse/Parse.h>

@implementation problem

+ (void) text:(NSString *)text withDelegate:(id<ProblemDelegate>)delegate {
    
    PFObject *problem = [PFObject objectWithClassName:@"Problem"];
    problem[@"userId"] = [PFObject objectWithoutDataWithClassName:@"_User" objectId:[PFUser currentUser].objectId];
    problem[@"issue"] = text;
    
    [delegate problemDidSend:YES];
    [problem saveInBackground];
}

@end
