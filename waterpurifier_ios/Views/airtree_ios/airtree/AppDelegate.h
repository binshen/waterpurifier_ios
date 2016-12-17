//
//  AppDelegate.h
//  BasicProgramExample
//
//  Created by Gloria on 16/11/7.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSTimeInterval _backgroundRunningTimeInterval;
}

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)AppInstance;
- (void)showHomePage;
- (void)showLoginPage;

@end

