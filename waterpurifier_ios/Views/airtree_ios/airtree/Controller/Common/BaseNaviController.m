//
//  BaseNaviController.m
//  airtree
//
//  Created by WindShan on 2016/11/11.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseNaviController.h"

@interface BaseNaviController ()

@end

@implementation BaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                BLACKTEXTCOLOR_TITLE,  NSForegroundColorAttributeName,
                                                [UIColor whiteColor], NSShadowAttributeName,
                                                [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], NSShadowAttributeName,
                                                [UIFont fontWithName:@"Arial-Bold" size:16.0f], NSFontAttributeName,
                                                nil]];
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(20, 10, 40, 20);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    [[self navigationItem] setLeftBarButtonItem: newBackButton];
}

-(void)backAction
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
