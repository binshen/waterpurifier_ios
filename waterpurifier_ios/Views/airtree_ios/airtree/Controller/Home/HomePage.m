//
//  HomePage.m
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "HomePage.h"
#import "PageInfo.h"

@interface HomePage ()

@end

@implementation HomePage

- (id)init
{
    self = [super init];
    if (self) {
        [self addTabControllers];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTabControllers
{
    self.tabBar.tintColor = NAVIGATIONTINTCOLOR;
    self.viewControllers = [PageInfo pageControllers];
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
