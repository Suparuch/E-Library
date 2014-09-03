//
//  ReportViewController.m
//  eBook
//
//  Created by Sittikorn on 9/3/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "ReportViewController.h"
#import <Parse/Parse.h>
#import "problem.h"

@interface ReportViewController () <ProblemDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITextView *reportTextView;
- (IBAction)sendAction:(id)sender;

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    self.title = @"Report a Problem";
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    singleTapRecognizer.numberOfTouchesRequired = 1;
    singleTapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTapRecognizer];
}

- (void) handleTapFrom: (UITapGestureRecognizer *) recognizer {
    // hide the keyboard
    [self.reportTextView resignFirstResponder];
}
- (void) setUI {
    
    [[self.reportTextView layer] setBorderWidth:1.0f];
    [[self.reportTextView layer] setCornerRadius:6.0f];
    [[self.reportTextView layer] setBorderColor:[UIColor grayColor].CGColor];
    
    self.usernameLabel.text = [PFUser currentUser].email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(id)sender {
    if ([self.reportTextView.text length] > 0) {
        [problem text:self.reportTextView.text withDelegate:self];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"ขอโทษคะ"
                                    message:@"กรุณาใส่ข้อความ เพื่อแจ้งปัญหาการใข้งาน\n ขอบคุณคะ"
                                   delegate:nil
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
    }
}

-(void) problemDidSend:(BOOL)send {
    if (send) {
        [[[UIAlertView alloc] initWithTitle:@"เรียบร้อน"
                                    message:@"แจ้งปัญหาการใช้งานเรียบร้อยแล้วค่ะ \nเราจะนำปัญหาไปแก้ไข \nขอบคุณคะ"
                                   delegate:self
                          cancelButtonTitle:@"ตกลง"
                          otherButtonTitles:nil] show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
