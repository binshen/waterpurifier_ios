//
//  BasePageController.h
//  airtree
//
//  Created by WindShan on 2016/11/11.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePageController : UIViewController
{
    
}

- (void)setNavigationTitleImage:(NSString *)imageName;
- (void)setNavigationLeft:(NSString *)imageName sel:(SEL)sel;
- (void)setNavigationRight:(NSString *)imageName sel:(SEL)sel;
- (void)setStatusBarStyle:(UIStatusBarStyle)style;

-(instancetype)	initIsFirstPage:(BOOL) isFirst;
-(void) backAction;
@end
