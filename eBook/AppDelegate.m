//
//  AppDelegate.m
//  eBook
//
//  Created by Sittikorn on 9/1/2557 BE.
//  Copyright (c) 2557 Sittikorn. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "StoreViewController.h"
#import "SettingViewController.h"
#import "ShelfViewController.h"
#import "Reachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    [Parse setApplicationId:@"rwGuh8JoEfakRipXoGzbgpE6x7kfg8rDZbmmOulG"
                  clientKey:@"iBiQCuogARC38uyPFvSG9Yt4Rog76psbX1j2wuGk"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reachability.reachableBlock = ^(Reachability *reachability) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IsConnected"];
        NSLog(@"Network is reachable.");
    };
    
    reachability.unreachableBlock = ^(Reachability *reachability) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IsConnected"];
        NSLog(@"Network is unreachable.");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Your Network is unreachable" delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil, nil];
        [alertView show];
    };
    
    [reachability startNotifier];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    StoreViewController  *storeView = [[StoreViewController alloc] init];
    ShelfViewController *shelfView = [[ShelfViewController alloc]init];
    
    UINavigationController *myNav1=[[UINavigationController alloc] initWithRootViewController:storeView];
    UINavigationController *myNav2=[[UINavigationController alloc] initWithRootViewController:shelfView];


    /*
     [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor_HexString colorFromHexString:@"#FFFFFF"]}]; //change coloer title name
     [[UITabBar appearance] setTintColor:[UIColor_HexString colorFromHexString:@"#87CEFA"]]; //change color tabbar icon
     
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; //change status bar
     */
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:myNav1,myNav2, nil];
    
    //set the login view
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
