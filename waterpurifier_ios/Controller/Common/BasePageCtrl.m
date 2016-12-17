//
// Created by Bin Shen on 16/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "BasePageCtrl.h"

@interface BasePageCtrl ()
{
    BOOL isFirstPage;
}
@end

@implementation BasePageCtrl

-(instancetype) init
{
    if (self = [super init] )
    {

    }

    return self;
}

-(id) initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(instancetype)	initIsFirstPage:(BOOL) isFirst
{
    if (self = [super init]) {
        isFirstPage = isFirst;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BGCOLOR;
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"白色图"] forBarMetrics:UIBarMetricsDefault];////why? zxt

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    titleLabel.textColor = NAVIGATIONTINTCOLOR;
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    if (!isFirstPage)
    {

        [self setNavBarImage];
        [Application setStatusBarHidden:NO];
        [self setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navigationController setNavigationBarHidden:NO animated:NO];

//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        backBtn.frame = CGRectMake(10, 10, 30, 30);
//        [backBtn setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//
//        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//        [[self navigationItem] setLeftBarButtonItem: newBackButton];
    }

}


- (void)setNavigationTitleImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

    self.navigationItem.titleView = imageView;
}

- (void)setNavBarImage
{
    UIImage *image = [UIImage imageNamed:[Global isSystemLowIOS7]?@"NavigationBar44.png":@"NavigationBar64.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    NSDictionary *attribute = @{
            NSForegroundColorAttributeName:[UIColor whiteColor],
            NSFontAttributeName:[UIFont systemFontOfSize:18]
    };

    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
}

- (UIButton *)customButton:(NSString *)imageName
                  selector:(SEL)sel
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];

    return btn;
}

- (void)setNavigationLeft:(NSString *)imageName sel:(SEL)sel
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:sel]];

    self.navigationItem.leftBarButtonItem = item;
}

- (void)setNavigationRight:(NSString *)imageName sel:(SEL)sel
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self customButton:imageName selector:sel]];

    self.navigationItem.rightBarButtonItem = item;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)style
{
    [Application setStatusBarStyle:style];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end