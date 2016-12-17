//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "BaseNavCtrl.h"


@implementation BaseNavCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.backgroundColor = [UIColor whiteColor];

    [self.navigationBar setTitleTextAttributes:[
            NSDictionary dictionaryWithObjectsAndKeys:
            BLACKTEXTCOLOR_TITLE,  NSForegroundColorAttributeName,
            [UIColor whiteColor], NSShadowAttributeName,
            [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], NSShadowAttributeName,
            [UIFont fontWithName:@"Arial-Bold" size:16.0f], NSFontAttributeName, nil
    ]];

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
@end