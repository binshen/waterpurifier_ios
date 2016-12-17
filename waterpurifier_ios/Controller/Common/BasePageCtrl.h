//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//


@interface BasePageCtrl : UIViewController

- (void)setNavigationTitleImage:(NSString *)imageName;
- (void)setNavigationLeft:(NSString *)imageName sel:(SEL)sel;
- (void)setNavigationRight:(NSString *)imageName sel:(SEL)sel;
- (void)setStatusBarStyle:(UIStatusBarStyle)style;

-(instancetype)	initIsFirstPage:(BOOL) isFirst;
-(void) backAction;

@end