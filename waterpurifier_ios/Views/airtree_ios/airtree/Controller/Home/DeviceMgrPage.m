//
//  DeviceMgrPage.m
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "DeviceMgrPage.h"
#import "DeviceInfoWidget.h"
#import "SettingPage.h"
#import "MonitorPage.h"
#import "BaseNaviController.h"
#import "ManageDeviceListPage.h"
@interface DeviceMgrPage ()<UIScrollViewDelegate>
{
    UIScrollView * diviceScrollView;
    UIPageControl * devicePageControl;
    
    NSUInteger numberPages;
    
    UIActivityIndicatorView *spinner;
}

@end

@implementation DeviceMgrPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RegisterNotify(NotifyDevideInfo, @selector(monitorInfo:));
    
    
    [self setNavigationLeft:@"ic_person.png" sel:@selector(personInfoAction)];
    [self setNavigationItem:@"管理" color:[UIColor whiteColor] selector:@selector(deviceListAction) isRight:YES];
    //[self setNavigationRight:<#(NSString *)#>:@"ic_person" sel:@selector(personInfoAction)];
    // 初始化 scrollview
    diviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    diviceScrollView.bounces = YES;
    diviceScrollView.pagingEnabled = YES;// 自动滚动到subview的边界
    diviceScrollView.delegate = self;
    diviceScrollView.userInteractionEnabled = YES;
    diviceScrollView.showsHorizontalScrollIndicator = NO;
    //diviceScrollView.backgroundColor = BLUE_BUTTON_COLOR;
    [self.view addSubview:diviceScrollView];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(SCREEN_WIDTH/2, ScreenHeight/3);//只能设置中心，不能设置大小
    [self.view addSubview:spinner];
    [spinner setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    // 初始化 pagecontrol
    CGFloat heightOffset = 0;
    if(IsiPhone4 || IsiPhone5)
        heightOffset = -140;
    else
        heightOffset = -180;
    devicePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,SCREEN_HEIGHT+heightOffset,100,20)]; // 初始化mypagecontrol
    [devicePageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [devicePageControl setPageIndicatorTintColor:[UIColor blackColor]];
    devicePageControl.hidesForSinglePage = YES;
    devicePageControl.userInteractionEnabled = NO;
    [devicePageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:devicePageControl];
    //deviceAirView.delegate = self;
    
    [self getUserDeviceInfo];
    
    // 创建四个图片 imageview
    
//    for (int i = 0; i < 10;i++)
//    {
//        DeviceInfoWidget * deviceInfoWidget = [[DeviceInfoWidget alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100) title:@""];
//        [diviceScrollView addSubview:deviceInfoWidget]; // 首页是第0页,默认从第1页开始的。所以+320。。。
//    }

    //[diviceScrollView setContentSize:CGSizeMake(10*SCREEN_WIDTH,  SCREEN_HEIGHT-60)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [diviceScrollView setContentOffset:CGPointMake(0, 0)];
    [diviceScrollView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT-60) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    // Do any additional setup after loading the view.
}

// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = diviceScrollView.frame.size.width;
    int page = floor((diviceScrollView.contentOffset.x - pagewidth/10)/pagewidth)+1;
    //page --;  // 默认从第二页开始
    FxLog(@"2 currentPage %d",page);
    devicePageControl.currentPage = page;
}
// sc
// scrollview 委托函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = diviceScrollView.frame.size.width;
     FxLog(@" 1 pagewidth %ld",pagewidth);
    int currentPage = floor((diviceScrollView.contentOffset.x - pagewidth/10)/pagewidth)+1;
    FxLog(@" 1 currentPage %d",currentPage);
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*currentPage,0,SCREEN_WIDTH, SCREEN_HEIGHT-60) animated:NO]; // 最后+1,循环第1页
    
    NSDictionary *device = [self.contentList objectAtIndex:currentPage];
    
    if([device objectForKey:@"name"])
    {
        self.navigationItem.title = device[@"name"];
    }
    else if([device objectForKey:@"mac"])
    {
        self.navigationItem.title = device[@"mac"];
    }
    else
    {
        self.navigationItem.title = @"房间";
    }

    
//    if (currentPage==0)
//    {
//        [diviceScrollView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 序号0 最后1页
//    }
//    else
//    {
//        [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 最后+1,循环第1页
//    }
}

-(void)personInfoAction
{
    // 跳转用户信息界面
    SettingPage *page = [[SettingPage alloc] initIsFirstPage:NO];
    BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
    [self presentViewController:loginNav animated:YES completion:nil];
    
}

-(void)deviceListAction
{
    // 跳转设备列表信息界面
    ManageDeviceListPage * deviceListPage = [[ManageDeviceListPage alloc] initIsFirstPage:NO];
    deviceListPage.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deviceListPage animated:YES];
}


- (void) getUserDeviceInfo
{
    
    // 执行登录操作
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"正在加载数据...";
//    // 隐藏时候从父控件中移除
//    HUD.removeFromSuperViewOnHide = YES;
//    // YES代表需要蒙版效果
//    HUD.dimBackground = YES;
    
    NSString *path = [NSString stringWithFormat:@"/user/%@/get_device", _loginUser[@"_id"]];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    MKNetworkHost *host = [[MKNetworkHost alloc] initWithHostName:MORAL_API_BASE_PATH];
    MKNetworkRequest *request = [host requestWithPath:path params:param httpMethod:@"GET"];
    [request addCompletionHandler: ^(MKNetworkRequest *completedRequest) {
        //NSString *response = [completedRequest responseAsString];
        //NSLog(@"Response: %@", response);
        //HUD.hidden = YES;
        [spinner stopAnimating];
        
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        // 解决OOM问题
        [[diviceScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 初始化page control的内容
        self.contentList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (data != nil && [self.contentList count] != 0) {
            // 一共有多少页
            numberPages = self.contentList.count;
            // 存储所有的controller
            NSMutableArray *controllers = [[NSMutableArray alloc] init];
            for (NSUInteger i = 0; i < numberPages; i++)
            {
                [controllers addObject:[NSNull null]];
            }
            
            self.viewControllers = controllers;
            
            diviceScrollView.contentSize = CGSizeMake(diviceScrollView.frame.size.width * numberPages, diviceScrollView.frame.size.height);
            
            devicePageControl.numberOfPages = numberPages;
            [devicePageControl setHidden:NO];
            
            if(devicePageControl.currentPage < 1)
            {
                NSDictionary *device = [self.contentList objectAtIndex:0];
                self.navigationItem.title = [device objectForKey:@"name"] ? device[@"name"] : device[@"mac"];
            }
            
//            for (NSUInteger i = 0; i < numberPages; i++)
//            {
//
//                DeviceInfoWidget * deviceInfoWidget = [[DeviceInfoWidget alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100) title:@""];
//                [diviceScrollView addSubview:deviceInfoWidget]; // 首页是第0页,默认从第1页开始的。所以+320。。。
//            }
            
        }
        else
        {
            self.navigationItem.title = @"房间";
            devicePageControl.numberOfPages = 0;
        }

    }];
    
    spinner.transform = CGAffineTransformMakeScale(1.5, 1.5);
    spinner.center = self.view.center;
    [spinner startAnimating];
    
    [host startRequest:request];
}


- (void)monitorInfo:(NSNotification *)notification
{
    NSDictionary *dict = [notification object];

    int * tag = [[dict valueForKey:@"tag"] intValue];
    
    MonitorPage *page = [[MonitorPage alloc] initIsFirstPage:NO];
    BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
    page.currentPage = tag;
    [self presentViewController:loginNav animated:YES completion:nil];
    
//    MonitorPage * page = [[MonitorPage alloc] initIsFirstPage:NO];
//    [self presentModalViewController:page animated:YES];
    //[self.navigationController pushViewController:page animated:NO];
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = devicePageControl.currentPage; // 获取当前的page
    FxLog(@" 3 currentPage %d",page);
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*(page+1),0,SCREEN_WIDTH,SCREEN_HEIGHT-60) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

- (void)didReceiveMemoryWarning
{
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
