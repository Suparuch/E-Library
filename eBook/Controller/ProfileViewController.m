//
//  ProfileViewController.m
//  RedCross
//
//  Created by Suparuch Sriploy on 5/6/14.
//  Copyright (c) 2014 Suparuch Sriploy. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "GBPathImageView.h"
#import "LoginViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;

@end

@implementation ProfileViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializatio
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Profile";
    
    [self userPhoto];
    [self setText];
    [self logoutButton];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) userPhoto {
    PFUser *user = [PFUser currentUser];
    PFFile *userImageFile = user[@"image"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *imageView = [UIImage imageWithData:imageData];
            GBPathImageView *squareImage = [[GBPathImageView alloc] initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height) image:imageView pathType:GBPathImageViewTypeCircle pathColor:[UIColor whiteColor] borderColor:[UIColor whiteColor] pathWidth:1.0];
            [self.view addSubview:squareImage];
        }
    }];
}

-(void) setText {
    
    self.emailLabel.text = [PFUser currentUser].email;
    
    PFUser *user = [PFUser currentUser];
    self.nameLabel.text = user[@"name"];
    self.genderLabel.text = user[@"gender"];
    self.birthdayLabel.text = user[@"birthDay"];
    
}

- (void)logoutButton
{
    /*
     UIBarButtonItem *editButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"LogoEdit.png"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(showEdit:)];*/
    
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc]initWithTitle:@"logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout:)];
    
    logOut.imageInsets = UIEdgeInsetsMake(0, -35, 0, 0);
    
    self.navigationItem.rightBarButtonItems = @[logOut];
}


- (IBAction)logout:(id)sender {
    
    [PFUser logOut];
    
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController presentViewController:login animated:NO completion:nil];
}
@end
