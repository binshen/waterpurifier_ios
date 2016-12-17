//
//  AppDelegate.m
//  BasicProgramExample
//
//  Created by Gloria on 16/11/7.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginPage.h"
#import "BaseNaviController.h"
#import "FogetPwdPage.h"
#import "RegistPage.h"
#import "SettingPage.h"
#import "HomePage.h"
#import "BackgroundRunner.h"
#import "BaseWebPage.h"
#import "MonitorPage.h"
#import "AddDevicePage.h"
#import "OldHomePage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)AppInstance;
{
     return  (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)showHomePage
{
//    HomePage *page = [[HomePage alloc] init];
//    self.window.rootViewController = page;
//    [self.window makeKeyAndVisible];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    OldHomePage *root = [[OldHomePage alloc]init];
    BaseNaviController *nav = [[BaseNaviController alloc]initWithRootViewController:root];//先将root添加在navigation上
    nav.navigationBarHidden = YES;
    [self.window setRootViewController:nav];//navigation加在window上
    [self.window makeKeyAndVisible];
}

- (void)showLoginPage
{
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
    
    // 运行后台程序
    _backgroundRunningTimeInterval = 0;
    //[self performSelectorInBackground:@selector(runningInBackground) withObject:nil];
    
    //test
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    OldHomePage *root = [[OldHomePage alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];//先将root添加在navigation上
//    nav.navigationBarHidden = YES;
//    [self.window setRootViewController:nav];//navigation加在window上
//    [self.window makeKeyAndVisible];
//    return YES;
    // end
    
    if([UserDefault stringForKey:@"isLogin"] != nil && [[UserDefault stringForKey:@"isLogin"] intValue] == 1 )
    {
        // 跳转主界面
        [GetAppDelegate getUserInfo];
    }
    else
    {
//        _loginUser[@"_id"] = [UserDefault stringForKey:@"user_id"];
//        [self runHeartbeatService];

        // 初始化登录状态 0 未登录 1 已登录
        [UserDefault setObject:@"0" forKey:@"isLogin"];
        
        [self showLoginPage];

    }

    return YES;
}


- (void)runningInBackground
{
    while (TRUE)
    {
        [NSThread sleepForTimeInterval:9999999];
        _backgroundRunningTimeInterval++;
        NSLog(@"Heartbeat: %d",(int)_backgroundRunningTimeInterval);
        [self runHeartbeatService];
    }
}

- (void) runHeartbeatService
{
    if (_loginUser[@"_id"] == nil)
    {
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"/user/%@/online", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:HTTPPOST];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest)
    {
        NSString *response = [completedRequest responseAsString];
        BASE_INFO_FUN(response);
    }];
    
    [host startRequest:request];
}

-(void)getUserInfo
{
    
    NSString *path = [[NSString alloc] initWithFormat:@"/user/%@/get_info",[UserDefault stringForKey:@"user_id"]];

    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    
    MKNetworkRequest *request = [host requestWithPath:path];
    BASE_INFO_FUN(path);
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {

        NSString *response = [completedRequest responseAsString];
        BASE_INFO_FUN(response);
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        if (data == nil)
        {
            BASE_ERROR_FUN(error);
            [Global alertMessageEx:@"请检查网络." title:@"用户信息获取失败" okTtitle:nil cancelTitle:@"确定" delegate:self];
            //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查网络." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alert show];
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSString *success = [json objectForKey:@"success"];
            BASE_INFO_FUN(json);
            NSDictionary *user = [json objectForKey:@"user"];
            if ( success != nil && [success boolValue] && ![user isEqual:[NSNull null]])
            {
                _loginUser = [user mutableCopy];
                
                // 存储用户信息
                [UserDefault setObject:@"1" forKey:@"isLogin"];
                [UserDefault setObject:user[@"_id"] forKey:@"user_id"];
                [UserDefault setObject:user[@"username"] forKey:@"username"];
                [UserDefault setObject:user[@"password"] forKey:@"password"];
                [UserDefault setObject:user[@"nickname"] forKey:@"nickname"];
                [UserDefault setObject:user[@"email"] forKey:@"email"];
                [UserDefault synchronize];//使用synchronize强制立即将数据写入磁盘,防止在写完NSUserDefaults后程序退出导致的数据丢失
                
                [GetAppDelegate showHomePage];

            }
            else
            {
                [UserDefault setObject:@"0" forKey:@"isLogin"];
                [Global alertMessageEx:@"用户信息错误." title:@"用户信息获取失败" okTtitle:nil cancelTitle:@"确定" delegate:self];
                
                [self showLoginPage];
                //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"输入的用户名或密码错误." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                //[alert show];
            }
        }
    }];
    
    [host startRequest:request];

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    
    if ([[UIDevice currentDevice] isMultitaskingSupported])
    {
      //  [[BackgroundRunner sharedInstance] run];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[BackgroundRunner sharedInstance] stop];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
