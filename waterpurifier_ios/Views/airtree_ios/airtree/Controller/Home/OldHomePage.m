//
//  OldHomePage.m
//  airtree
//
//  Created by WindShan on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "OldHomePage.h"
#import "DeviceInfoWidget.h"
#import "SettingPage.h"
#import "MonitorPage.h"
#import "BaseNaviController.h"
#import "ManageDeviceListPage.h"
#import "BottomButtonView.h"
#import "OnlineShopPage.h"
#import "GloriaLabel.h"

@interface OldHomePage ()<UIScrollViewDelegate,BottomButtonDelegate>
{
    UIScrollView * diviceScrollView;
    UIPageControl * devicePageControl;
    
    NSUInteger numberPages;
    
    UIActivityIndicatorView *spinner;
    
    NSTimer *updateTimer;
    GloriaLabel * roomTitleLabel;
    NSInteger alarmType; // 0 无 1 湿度 2 颗粒 3 甲醛 4 温度
}
@end

@implementation OldHomePage

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(getUserDeviceInfo) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    if(updateTimer != nil)
    [updateTimer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    alarmType = 0;
    RegisterNotify(NotifyDevideInfo, @selector(monitorInfo:));
    
    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    UIImageView * backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    backgroundImage.image = [UIImage imageNamed:@"room_bg"];
    [self.view addSubview:backgroundImage];
    
    UIButton* personalSetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalSetBtn.frame = CGRectMake(10, 20,44, 44);
    [personalSetBtn setImage:[UIImage imageNamed:@"ic_person.png"] forState:UIControlStateNormal];
    personalSetBtn.backgroundColor = [UIColor clearColor];;
    [personalSetBtn addTarget:self action:@selector(personInfoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personalSetBtn];
    
    roomTitleLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    roomTitleLabel.textAlignment = UITextAlignmentCenter;
    roomTitleLabel.font = [UIFont systemFontOfSize: 18.0];
    [roomTitleLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:roomTitleLabel];
    //[self setNavigationLeft:@"ic_person.png" sel:@selector(personInfoAction)];
    
    //[self setNavigationRight:<#(NSString *)#>:@"ic_person" sel:@selector(personInfoAction)];
    // 初始化 scrollview
    diviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    diviceScrollView.bounces = YES;
    diviceScrollView.pagingEnabled = YES;// 自动滚动到subview的边界
    diviceScrollView.delegate = self;
    diviceScrollView.userInteractionEnabled = YES;
    diviceScrollView.showsHorizontalScrollIndicator = NO;
    diviceScrollView.scrollsToTop = NO;
    //diviceScrollView.backgroundColor = BLUE_BUTTON_COLOR;
    [self.view addSubview:diviceScrollView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [diviceScrollView addGestureRecognizer:doubleTap];
    
    // 初始化 pagecontrol
    CGFloat heightOffset = 0;
    if(IsiPhone4 || IsiPhone5)
        heightOffset = -80;
    else if (IsiPhone6P)
        heightOffset = -180;
    else
        heightOffset = -120;

    devicePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,SCREEN_HEIGHT+heightOffset,100,20)]; // 初始化mypagecontrol
    [devicePageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    devicePageControl.hidesForSinglePage = YES;
    devicePageControl.userInteractionEnabled = NO;
    [devicePageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:devicePageControl];
    //deviceAirView.delegate = self;
    //[self getUserDeviceInfo];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(SCREEN_WIDTH/2, ScreenHeight/3);//只能设置中心，不能设置大小
    [self.view addSubview:spinner];
    [spinner setHidesWhenStopped:YES]; //当旋转结束时隐藏
    
    UIView * buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    [self.view addSubview:buttonView];
    
    UIImageView * lineImgaeView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2,10, 1, 40)];
    lineImgaeView.image = [UIImage imageNamed:@"line_icon"];
    [buttonView addSubview:lineImgaeView];
    
    BottomButtonView * deviceBottomView = [[BottomButtonView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-1, 60) imagename:@"ic_device_30" titile:@"设备管理"];
    deviceBottomView.tag = 101;
    deviceBottomView.delegate = self;
    [buttonView addSubview:deviceBottomView];
    
    BottomButtonView * shopBottomView = [[BottomButtonView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 0, SCREEN_WIDTH/2-1, 60) imagename:@"ic_device_30" titile:@"在线商城"];
    shopBottomView.tag = 102;
    shopBottomView.delegate = self;
    [buttonView addSubview:shopBottomView];
    
    [self getUserDeviceInfo];
    
//    UIButton * deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    deviceBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 110);
//    [deviceBtn setTitle:@"设备管理" forState:UIControlStateNormal];
//    deviceBtn.backgroundColor = BLUE_BUTTON_COLOR;
//    deviceBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
//    [deviceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    deviceBtn.layer.masksToBounds=YES;
//    deviceBtn.layer.cornerRadius=8.0f;
//    [deviceBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
//    [buttonView addSubview:deviceBtn];
    
    
    // 创建四个图片 imageview
//        for (int i = 0; i < 10;i++)
//        {
//            DeviceInfoWidget * deviceInfoWidget = [[DeviceInfoWidget alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120) title:@""];
//            [diviceScrollView addSubview:deviceInfoWidget]; // 首页是第0页,默认从第1页开始的。所以+320。。。
//        }
    
   // [diviceScrollView setContentSize:CGSizeMake(10*SCREEN_WIDTH,  SCREEN_HEIGHT-80)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [diviceScrollView setContentOffset:CGPointMake(0, 0)];
    [diviceScrollView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT-80) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
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
    
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*currentPage,0,SCREEN_WIDTH, SCREEN_HEIGHT-80) animated:NO]; // 最后+1,循环第1页
    
    NSDictionary *device = [self.contentList objectAtIndex:currentPage];
    
    if([device objectForKey:@"name"])
    {
        roomTitleLabel.text = device[@"name"];
    }
    else if([device objectForKey:@"mac"])
    {
        roomTitleLabel.text = device[@"mac"];
    }
    else
    {
        roomTitleLabel.text = @"房间";
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

- (void) doDoubleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        NSLog(@"Double Click");
        if(updateTimer != nil)
            [updateTimer invalidate];
        updateTimer= [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(getUserDeviceInfo) userInfo:nil repeats:YES];
       
        [self getUserDeviceInfo];
    }
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
        NSString *response = [completedRequest responseAsString];
        BASE_INFO_FUN(response);
        //NSLog(@"Response: %@", response);
        //HUD.hidden = YES;
         [spinner stopAnimating];
        NSError *error = [completedRequest error];
        NSData *data = [completedRequest responseData];
        
        // 解决OOM问题
        [[diviceScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        // 初始化page control的内容
        self.contentList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (data != nil && [self.contentList count] != 0)
        {
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
                roomTitleLabel.text = [device objectForKey:@"name"] ? device[@"name"] : device[@"mac"];
            }
            
            for (NSUInteger i = 0; i < numberPages; i++)
            {
                NSDictionary * device = [self.contentList objectAtIndex:i];
                
                DeviceInfoWidget * deviceInfoWidget = [[DeviceInfoWidget alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-120) pageIndex:i];
                [diviceScrollView addSubview:deviceInfoWidget]; // 首页是第0页,默认从第1页开始的。所以+320。。。
                NSString *status = device[@"status"];
                NSDictionary *data = device[@"data"];
                if ([status longLongValue] == 1)
                {
                    [deviceInfoWidget setSuggestLabel:@"云端在线"];
                    
                    NSString *type = device[@"type"];
                    
                    if ([type longLongValue] == 1)
                    {
                        if ((NSNull *) data == [NSNull null] || ![data objectForKey:@"x13"])
                        {
                            [deviceInfoWidget setElectricImage:@"ic_ele_n0s.png"];
                        }
                        else
                        {
                            [deviceInfoWidget setElectricImage:[NSString stringWithFormat:@"ic_ele_n%@s.png", data[@"x13"]]];
                        }
                    }
                    else
                    {
                        [deviceInfoWidget setElectricImage:@"ic_ele_n4s.png"];
                    }
                    
                    [deviceInfoWidget setElectricHidded:NO];
                }
                else
                {
                    if ((NSNull *) data == [NSNull null])
                    {
                        [deviceInfoWidget setSuggestLabel:@""];
                    }
                    else
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]];
                        [deviceInfoWidget setSuggestLabel:[NSString stringWithFormat:@"上次检测时间:\n%@", dateString]];
                    }
                    
                    [deviceInfoWidget setElectricHidded:YES];
                }
                
                if ((NSNull *) data == [NSNull null])
                {
                    [deviceInfoWidget setDevicePM25View:@"0ug/m³"];
                    [deviceInfoWidget setDeviceWenduView:@"0℃"];
                    [deviceInfoWidget setDeviceShiduView:@"0%"];
                    [deviceInfoWidget setDeviceJiaquanView:@"0mg/m³"];
                    [deviceInfoWidget setSuggestLabel:@""];
                    [deviceInfoWidget setAirQualityLabel:@"未知"];
                }
                else
                {
                    NSInteger p1 = [data[@"p1"] integerValue];
                    if(p1 == 3)
                    {
                        if([data objectForKey:@"x9"])
                        {
                            float x9 = [data[@"x9"] floatValue];
                            if(x9 == 0)
                            {
                                [deviceInfoWidget setAlarmScoreLabel:@"0"];
                                //                                /[self.main setText:@"0"];
                            }
                            else
                            {
                                [deviceInfoWidget setAlarmScoreLabel:[NSString stringWithFormat:@"%.2f", [data[@"x9"] floatValue]]];
                            }
                            
                            [deviceInfoWidget setAlarmType:3]; //设置报警类型
                            [deviceInfoWidget setAlarmPromptLabel:@"当前甲醛浓度（mg/m³）"];
                            //[self.mainLable setText:@"当前甲醛浓度（mg/m³）"];
                        }
                        else
                        {
                            [deviceInfoWidget setAlarmScoreLabel:@"未知"];
                            [deviceInfoWidget setAlarmPromptLabelHidded:YES];
                            //[self.mainLable setHidden:YES];
                        }
                        
                    }
                    else if(p1 == 4)
                    {
                        if([data objectForKey:@"x11"])
                        {
                            [deviceInfoWidget setAlarmType:4]; //设置报警类型
                            [deviceInfoWidget setAlarmScoreLabel:[NSString stringWithFormat:@"%@", data[@"x11"]]];
                            [deviceInfoWidget setAlarmPromptLabel:@"当前温度（℃）"];
                        }
                        else
                        {
                            [deviceInfoWidget setAlarmScoreLabel:@"未知"];
                            [deviceInfoWidget setAlarmPromptLabelHidded:YES];
                            //                            [self.main setText:@"未知"];
                            //                            [self.mainLable setHidden:YES];
                        }
                    }
                    else
                    {
                        if([data objectForKey:@"x1"])
                        {
                            [deviceInfoWidget setAlarmType:2]; //设置报警类型
                            [deviceInfoWidget setAlarmScoreLabel:[NSString stringWithFormat:@"%@", data[@"x3"]]];
                            [deviceInfoWidget setAlarmPromptLabel:@"0.3um颗粒物个数"];
                        }
                        else
                        {
                            [deviceInfoWidget setAlarmScoreLabel:@"未知"];
                            [deviceInfoWidget setAlarmPromptLabelHidded:YES];
                        }
                    }
                    
                    NSString *pm25 = data[@"x1"];
                    [deviceInfoWidget setDevicePM25View:[NSString stringWithFormat:@"%@ug/m³", data[@"x1"]]];
                    [deviceInfoWidget setDeviceWenduView:[NSString stringWithFormat:@"%@℃", data[@"x11"]]];
                    [deviceInfoWidget setDeviceShiduView:[NSString stringWithFormat:@"%@%%", data[@"x10"]]];
                    
                    float x9 = [data[@"x9"] floatValue];
                    
                    if(x9 == 0)
                    {
                        [deviceInfoWidget setDeviceJiaquanView:@"0mg/m³"];
                    }
                    else
                    {
                        [deviceInfoWidget setDeviceJiaquanView:[NSString stringWithFormat:@"%.2fmg/m³", [data[@"x9"] floatValue]]];
                    }
                    
                    if(p1 > 0)
                    {
                        NSInteger feiLevel = [data[@"fei"] integerValue];
                        
                        if(feiLevel == 1)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"优"];
                            [deviceInfoWidget setMainImage:@"rank_1"];
                        }
                        else if(feiLevel == 2)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"良"];
                            [deviceInfoWidget setMainImage:@"rank_2"];
                        }
                        else if(feiLevel == 3)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"中"];
                            [deviceInfoWidget setMainImage:@"rank_3"];
                        }
                        else if(feiLevel == 4)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"差"];
                            [deviceInfoWidget setMainImage:@"rank_4"];
                        }
                        else
                        {
                            [deviceInfoWidget setAirQualityLabel:@"未知"];
                        }
                        
                    }
                    else
                    {
                        if([pm25 longLongValue] <= 35)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"优"];
                            [deviceInfoWidget setMainImage:@"rank_1"];
                        }
                        else if([pm25 longLongValue] <= 75)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"良"];
                            [deviceInfoWidget setMainImage:@"rank_2"];
                        }
                        else if([pm25 longLongValue] <= 150)
                        {
                            [deviceInfoWidget setAirQualityLabel:@"中"];
                            [deviceInfoWidget setMainImage:@"rank_3"];
                        }
                        else
                        {
                            [deviceInfoWidget setAirQualityLabel:@"差"];
                            [deviceInfoWidget setMainImage:@"rank_4"];
                        }
                    }
                    
                    NSInteger x14 = [data[@"x14"] integerValue];
                    if(x14 <= 0)
                    {
                        return;
                    }
                    
                    if(x14 > 500)
                    {
                        [deviceInfoWidget setLightImageView:@"light_01.png"];
                    }
                    else if(x14 < 240)
                    {
                        [deviceInfoWidget setLightImageView:@"light_03.png"];
                    }
                    else
                    {
                        [deviceInfoWidget setLightImageView:@"light_02.png"];
                    }
                    
                    
                    //[self loadScrollViewWithPage: i ];
                }
            }
            
        }
        else
        {
            roomTitleLabel.text = @"房间";
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
    NSInteger index = [[dict valueForKey:@"index"] integerValue];
    
    if([self checkDeviceStatus:[self.contentList objectAtIndex:index]])
    {
        return ;
    }
    
    MonitorPage *page = [[MonitorPage alloc] initIsFirstPage:NO];
    BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
    page.currentPage = tag;
    page.pageDevice =  [self.contentList objectAtIndex:index];
    [self presentViewController:loginNav animated:YES completion:nil];
    
    //    MonitorPage * page = [[MonitorPage alloc] initIsFirstPage:NO];
    //    [self presentModalViewController:page animated:YES];
    //[self.navigationController pushViewController:page animated:NO];
}

-(void)bottomButtonChoose:(id)sender
{
    BottomButtonView * bottomView = (BottomButtonView*)sender;
    
    switch (bottomView.tag) {
        case 101:
        {
            // 跳转设备列表信息界面
            ManageDeviceListPage *page = [[ManageDeviceListPage alloc] initIsFirstPage:NO];
            BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
            break;
        case 102:
        {
            OnlineShopPage *page = [[OnlineShopPage alloc] initIsFirstPage:NO];
            NSInteger index = devicePageControl.currentPage;
            DeviceInfoWidget * deviceInfoWidget = (DeviceInfoWidget *)[[diviceScrollView subviews] objectAtIndex:index];
            page.alarmType = deviceInfoWidget.alarmType;
            BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
            [self presentViewController:loginNav animated:YES completion:nil];
        }
            // 跳转设备列表信息界面
//            ManageDeviceListPage *page = [[ManageDeviceListPage alloc] initIsFirstPage:NO];
//            BaseNaviController *loginNav = [[BaseNaviController alloc] initWithRootViewController:page];
//            [self presentViewController:loginNav animated:YES completion:nil];
            break;
        default:
            break;
    }

    
//    ManageDeviceListPage * deviceListPage = [[ManageDeviceListPage alloc] initIsFirstPage:NO];
//    deviceListPage.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:deviceListPage animated:YES];
}

// pagecontrol 选择器的方法

- (void)turnPage
{
    int page = devicePageControl.currentPage; // 获取当前的page
    FxLog(@" 3 currentPage %d",page);
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*(page+1),0,SCREEN_WIDTH,SCREEN_HEIGHT-80) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
}

- (BOOL) checkDeviceStatus:(NSDictionary*) pageDevice
{
    if ([pageDevice[@"status"] integerValue] != 1)
    {
        [Global alertMessageEx:@"请启动FEI环境数设备" title:@"错误信息" okTtitle:nil cancelTitle:@"OK" delegate:self];
        return TRUE;
    } else {
        return FALSE;
    }
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
