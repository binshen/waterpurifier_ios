//
//  BaseNavPage.m
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseNavPage.h"

@interface BaseNavPage ()

@end

@implementation BaseNavPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barBackgroudImage = @"NavigationBar";
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self setNavigationBackground];
}

- (void)setNavigationBackground
{
    NSString *imageName = [self.barBackgroudImage stringByAppendingFormat:@"%d.png", [Global isSystemLowIOS7]?NavBarHeight:NavBarHeight7];
    UIImage *image = [UIImage imageNamed:imageName];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSDictionary *attribute = @{
                                NSForegroundColorAttributeName:[UIColor whiteColor],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
}



- (UIButton *)customButton:(NSString *)title
                  selector:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([title hasSuffix:@"png"]) {
        [btn setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    }
    else {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)setNavigationItem:(NSString *)title  color:(UIColor*)color selector:(SEL)selector isRight:(BOOL)isRight
{
    UIBarButtonItem *item = nil;
    
    if ([Global isSystemLowIOS7])
    {
        UIButton *btn = [self customButton:title selector:selector];
        item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    else
    {
        if ([title hasSuffix:@"png"])
        {
            item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:title] style:UIBarButtonItemStylePlain target:self action:selector];
        }
        else
        {
            item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
        }
        
        item.tintColor = color;
    }
    
    if (isRight)
        self.navigationItem.rightBarButtonItem = item;
    else
        self.navigationItem.leftBarButtonItem = item;
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
