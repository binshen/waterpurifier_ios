//
//  MonitorPage.m
//  airtree
//
//  Created by WindShan on 2016/11/17.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "MonitorPage.h"
#import "MonitorView.h"
@interface MonitorPage ()<UIScrollViewDelegate>
{
    UIScrollView * diviceScrollView;
    UIPageControl * devicePageControl;
}
@end

@implementation MonitorPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"";
    [self setNavigationLeft:@"返回" sel:@selector(backAction)];
    
    //[self setNavigationRight:<#(NSString *)#>:@"ic_person" sel:@selector(personInfoAction)];
    // 初始化 scrollview
    diviceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    diviceScrollView.bounces = YES;
    diviceScrollView.pagingEnabled = YES;// 自动滚动到subview的边界
    diviceScrollView.delegate = self;
    diviceScrollView.userInteractionEnabled = YES;
    diviceScrollView.showsHorizontalScrollIndicator = NO;
    //diviceScrollView.backgroundColor = BLUE_BUTTON_COLOR;
    [self.view addSubview:diviceScrollView];
    
    // 初始化 pagecontrol
    devicePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2,SCREEN_HEIGHT-100,100,20)]; // 初始化mypagecontrol
    [devicePageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [devicePageControl setPageIndicatorTintColor:[UIColor blackColor]];
    devicePageControl.numberOfPages = 4;
    devicePageControl.currentPage = [self currentPage];
    [devicePageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:devicePageControl];

    
    //deviceAirView.delegate = self;
    
    // 创建四个图片 imageview
    
    for (int i = 0; i < 4;i++)
    {
        MonitorView * view = [[MonitorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT) title:@""];
        
        if((NSNull *) self.pageDevice[@"data"] != [NSNull null] && self.pageDevice[@"data"] != nil)
        {
            NSDictionary *data = self.pageDevice[@"data"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [view setAirTimeLabelText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:([data[@"created"] longLongValue] / 1000)]]];

            if(i == 0)
            {
                [view setAirTitleLabelText: @"PM2.5"];
                [view setAirScoreLabelText:[NSString stringWithFormat:@"%@", data[@"x1"]]];
                [view setAirTagLabelText:@"ug/m³"];
                [view setAirDetailImageName:@"bg_pm_s.png"];
            }
            else if(i == 1)
            {
                [view setAirTitleLabelText: @"温度"];
                [view setAirScoreLabelText:[NSString stringWithFormat:@"%@", data[@"x11"]]];
                [view setAirTagLabelText:@"℃"];
                [view setAirDetailImageName:@"bg_wendu_s.png"];
            }
            else if(i == 2)
            {
                [view setAirTitleLabelText: @"湿度"];
                [view setAirScoreLabelText:[NSString stringWithFormat:@"%@", data[@"x10"]]];
                [view setAirTagLabelText:@"%"];
                [view setAirDetailImageName:@"bg_shidu_s.png"];
            }
            else
            {
                [view setAirTitleLabelText: @"甲醛"];
                [view setAirScoreLabelText:[NSString stringWithFormat:@"%@", data[@"x1"]]];
                [view setAirTagLabelText:@"mg/m³"];
                [view setAirDetailImageName:@"bg_jiaquan_s.png"];
                
                float x9 = [data[@"x9"] floatValue];
                if(x9 == 0)
                {
                    [view setAirScoreLabelText:@"0"];
                }
                else
                {
                    [view setAirScoreLabelText:[NSString stringWithFormat:@"%.2f", [data[@"x9"] floatValue]]];
                }
            }

            
            NSInteger p1 = [data[@"p1"] integerValue];
            if(p1 > 0)
            {
                NSInteger feiLevel = [data[@"fei"] integerValue];
                if(feiLevel == 1)
                {
                    [view setAirStatusLabelText:@"咱家空气棒棒哒，连呼吸都是甜的呢~"];
                    [view setAirStatusImageName:@"good"];
                }
                else if(feiLevel == 2)
                {
                    [view setAirStatusLabelText:@"空气不错哦~只要再一丢丢的努力就完美啦~"];
                    [view setAirStatusImageName:@"very"];
                    
                }
                else if(feiLevel == 3)
                {
                    [view setAirStatusLabelText:@"加把劲吧，咱家空气需要大大的改善~"];
                    [view setAirStatusImageName:@"general"];
                }
                else
                {
                    [view setAirStatusLabelText:@"你家的空气太糟糕啦，我要离家出走了~"];
                    [view setAirStatusImageName:@"poor"];
                }
            }
            else
            {
                NSInteger pmData = [data[@"x1"] integerValue];
                if(pmData <= 35)
                {
                    [view setAirStatusLabelText:@"咱家空气棒棒哒，连呼吸都是甜的呢~"];
                    [view setAirStatusImageName:@"good"];
                }
                else if(pmData <= 75)
                {
                    [view setAirStatusLabelText:@"空气不错哦~只要再一丢丢的努力就完美啦~"];
                    [view setAirStatusImageName:@"very"];
                }
                else if(pmData <= 150)
                {
                    [view setAirStatusLabelText:@"加把劲吧，咱家空气需要大大的改善~"];
                    [view setAirStatusImageName:@"general"];
                }
                else
                {
                    [view setAirStatusLabelText:@"你家的空气太糟糕啦，我要离家出走了~"];
                    [view setAirStatusImageName:@"poor"];
                }
            }
        }
        else
        {
            [view setAirTimeLabelText:@"0000-00-00 00:00:00"];
            [view setAirTitleLabelText:@""];
            [view setAirScoreLabelText:@"0"];
            [view setAirTagLabelText:@""];
            [view setAirDetailImageName:@"bg_pm"];
        }
        
        [diviceScrollView addSubview:view];
    }
    
    [diviceScrollView setContentSize:CGSizeMake(4*SCREEN_WIDTH,  SCREEN_HEIGHT)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [diviceScrollView setContentOffset:CGPointMake(0, 0)];
    [diviceScrollView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页
    
    
    [self turnPage];
    // Do any additional setup after loading the view.
    

    
    // Do any additional setup after loading the view.
}


// scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = diviceScrollView.frame.size.width;
    int page = floor((diviceScrollView.contentOffset.x - pagewidth/4)/pagewidth)+1;
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
    int currentPage = floor((diviceScrollView.contentOffset.x - pagewidth/4)/pagewidth)+1;
    FxLog(@" 1 currentPage %d",currentPage);
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    switch (currentPage) {
        case 0:
            self.title = @"PM2.5";
            break;
        case 1:
            self.title = @"温度";
            break;
        case 2:
            self.title = @"湿度";
            break;
        case 3:
            self.title = @"甲烷";
            break;
        default:
            break;
    }
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*currentPage,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 最后+1,循环第1页
    //    if (currentPage==0)
    //    {
    //        [diviceScrollView scrollRectToVisible:CGRectMake(0,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 序号0 最后1页
    //    }
    //    else
    //    {
    //        [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH,0,SCREEN_WIDTH, SCREEN_HEIGHT) animated:NO]; // 最后+1,循环第1页
    //    }
}

-(void)backAction
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    NSInteger page = devicePageControl.currentPage; // 获取当前的page
    FxLog(@" 3 currentPage %d",page);
    switch (page) {
        case 0:
            self.title = @"PM2.5";
            break;
        case 1:
            self.title = @"温度";
            break;
        case 2:
            self.title = @"湿度";
            break;
        case 3:
            self.title = @"甲烷";
            break;
        default:
            break;
    }
    [diviceScrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH*page,0,SCREEN_WIDTH,SCREEN_HEIGHT) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1
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
