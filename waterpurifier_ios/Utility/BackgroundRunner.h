//
//  BackgroundRunner.h
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundRunner : NSObject
{
    BOOL _free;
    BOOL _holding;
}

/** hold the thread when background task will terminate */
- (void)hold;

/** free from holding when applicaiton become active */
- (void)stop;

/** running in background, call this funciton when application become background */
- (void)run;


+ (BackgroundRunner *)sharedInstance;

@end
