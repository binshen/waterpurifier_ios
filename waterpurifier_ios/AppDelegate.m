//
//  AppDelegate.m
//  waterpurifier_ios
//
//  Created by Bin Shen on 16/12/2016.
//  Copyright © 2016 Bin Shen. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginPage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)AppInstance; {
    return  (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)showLoginPage {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    LoginPage *root = [[LoginPage alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];//先将root添加在navigation上
    nav.navigationBarHidden = YES;
    [self.window setRootViewController:nav];//navigation加在window上

    [self.window makeKeyAndVisible];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [NSThread sleepForTimeInterval:3.0];

    [self showLoginPage];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
