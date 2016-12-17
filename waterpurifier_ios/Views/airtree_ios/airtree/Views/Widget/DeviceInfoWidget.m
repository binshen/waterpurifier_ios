//
//  DeviceInfoWidget.m
//  airtree
//
//  Created by WindShan on 2016/11/16.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "DeviceInfoWidget.h"
#import "UIImage+animatedGIF.h"


@implementation DeviceInfoWidget
{
    UIImageView *electricImageView;//电池状态
    UIImageView *mainImageView;//环境状态动画
    UIImageView *lightImageView;//照明状态
    UILabel * airQualityLabel;//空气状态提示
    UILabel * alarmScoreLabel;//预警状态评分
    UILabel * alarmPromptLabel;//预警状态描述
    UILabel * suggestLabel;//终端状态描述
    
    DeviceButtonView * devicePM25View;
    DeviceButtonView * deviceWenduView;
    DeviceButtonView * deviceShiduView;
    DeviceButtonView * deviceJiaquanView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame pageIndex:(NSInteger)index
{
    if (self = [super init])
    {
        self.frame = frame;
        
//        UIImageView * backgroundImage = [[UIImageView alloc] initWithFrame:self.bounds];
//        backgroundImage.image = [UIImage imageNamed:@"room_bg"];
//        [self addSubview:backgroundImage];
        //[self setBackgroundColor:BLUE_BUTTON_COLOR];
        int offset = 0;
        CGFloat frontSize = 80.0;
        if( IsiPhone5 || IsiPhone4 )
        {
            offset = -20;
            frontSize = 60.0;
        }
        
        int deviceOffset = 0;
        if( IsiPhone5 || IsiPhone4 )
        {
            deviceOffset = -10;
        }
        
        electricImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-28)/2, 15, 28, 15)];
        [self addSubview:electricImageView];
        
        mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 100, 100)];
        [self addSubview:mainImageView];
        
        lightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-120, 40, 100, 100)];
        [self addSubview:lightImageView];
        
        airQualityLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-160)/2, 50, 160, 80)];
        airQualityLabel.textAlignment = UITextAlignmentCenter;
        [airQualityLabel setTextColor:[UIColor whiteColor]];
        [airQualityLabel setFont:[UIFont boldSystemFontOfSize:60]];
        [self addSubview:airQualityLabel];
        
        alarmScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140+offset, self.frame.size.width, 80)];
        alarmScoreLabel.textAlignment = UITextAlignmentCenter;
        [alarmScoreLabel setTextColor:[UIColor whiteColor]];
        [alarmScoreLabel setFont:[UIFont systemFontOfSize:frontSize]];
        [self addSubview:alarmScoreLabel];
        
        alarmPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 230+offset, self.frame.size.width, 20)];
        alarmPromptLabel.textAlignment = UITextAlignmentCenter;
        [alarmPromptLabel setTextColor:[UIColor whiteColor]];
        [alarmPromptLabel setFont:[UIFont systemFontOfSize:20.0]];
        [self addSubview:alarmPromptLabel];
        
        suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280+offset+deviceOffset, self.frame.size.width, 50)];
        suggestLabel.textAlignment = UITextAlignmentCenter;
        suggestLabel.numberOfLines = 2;
        [suggestLabel setTextColor:[UIColor whiteColor]];
        [suggestLabel setFont:[UIFont systemFontOfSize:20.0]];
        [self addSubview:suggestLabel];
        
        //test begin
        //[electricImageView setImage:[UIImage imageNamed:@"ic_ele_n4s.png"]];
        //[mainImageView setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"rank_1" withExtension:@"gif"]]];
        //[lightImageView setImage:[UIImage imageNamed:@"light_01.png"]];
        [airQualityLabel setText:@"未知"];
        [alarmScoreLabel setText:@"0"];
        [alarmPromptLabel setText:@"0.3um颗粒物个数"];
        //[suggestLabel setText:[NSString stringWithFormat:@"上次检测时间:\n%@", @"终端在线"]];
        
        
        //end

        
        int pageIndex = 0;
        //airScore:@"126ug/m³" airParam:@"PM2.5"
        devicePM25View = [[DeviceButtonView alloc] initWithFrame:CGRectMake((self.frame.size.width/4)*pageIndex, 360+offset+deviceOffset, self.frame.size.width/4, 96) isRight:YES pageIndex:[NSNumber numberWithInt:pageIndex]];
        devicePM25View.delegate = self;
        devicePM25View.tag = 0;
        [devicePM25View setAirScore:@"0ug/m³"];
        [devicePM25View setAirParam:@"PM2.5"];
        [self addSubview:devicePM25View];
        pageIndex++;
        //airScore:@"25℃" airParam:@"温度"
        deviceWenduView = [[DeviceButtonView alloc] initWithFrame:CGRectMake((self.frame.size.width/4)*pageIndex, 360+offset+deviceOffset, self.frame.size.width/4, 96) isRight:YES pageIndex:[NSNumber numberWithInt:pageIndex]];
        deviceWenduView.delegate = self;
        deviceWenduView.tag = 1;
        [deviceWenduView setAirScore:@"0℃"];
        [deviceWenduView setAirParam:@"温度"];
        [self addSubview:deviceWenduView];
        pageIndex++;
        //airScore:@"43%" airParam:@"湿度"
        deviceShiduView = [[DeviceButtonView alloc] initWithFrame:CGRectMake((self.frame.size.width/4)*pageIndex, 360+offset+deviceOffset, self.frame.size.width/4, 96) isRight:YES pageIndex:[NSNumber numberWithInt:pageIndex]];
        deviceShiduView.delegate = self;
        deviceShiduView.tag = 2;
        [deviceShiduView setAirScore:@"0%"];
        [deviceShiduView setAirParam:@"湿度"];
        [self addSubview:deviceShiduView];
        pageIndex++;
        //airScore:@"0.003mg/m³" airParam:@"甲醛"
        deviceJiaquanView = [[DeviceButtonView alloc] initWithFrame:CGRectMake((self.frame.size.width/4)*pageIndex, 360+offset+deviceOffset, self.frame.size.width/4, 96) isRight:NO pageIndex:[NSNumber numberWithInt:pageIndex]];
        deviceJiaquanView.delegate = self;
        deviceJiaquanView.tag = 3;
        [deviceJiaquanView setAirScore:@"0mg/m³"];
        [deviceJiaquanView setAirParam:@"甲烷"];
        [self addSubview:deviceJiaquanView];
        
    }
    
    return self;
}

-(void)setDevicePM25View:(NSString*)airscore
{
    [devicePM25View setAirScore:airscore];
    [devicePM25View setAirParam:@"PM2.5"];
}

-(void)setDeviceWenduView:(NSString*)airscore
{
    [deviceWenduView setAirScore:airscore];
    [deviceWenduView setAirParam:@"温度"];
}

-(void)setDeviceShiduView:(NSString*)airscore
{
    [deviceShiduView setAirScore:airscore];
    [deviceShiduView setAirParam:@"湿度"];
}

-(void)setDeviceJiaquanView:(NSString*)airscore
{
    [deviceJiaquanView setAirScore:airscore];
    [deviceJiaquanView setAirParam:@"甲烷"];
}

-(void) setElectricImage:(NSString*)imageName
{
    [electricImageView setImage:[UIImage imageNamed:imageName]];
}

-(void) setElectricHidded:(BOOL)bHide
{
    [electricImageView setHidden:bHide];
}

-(void) setMainImage:(NSString*)imageName
{
    [mainImageView setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:imageName withExtension:@"gif"]]];
}

-(void) setLightImageView:(NSString*)imageName
{
    [lightImageView setImage:[UIImage imageNamed:imageName]];
}

-(void)setAirQualityLabel:(NSString*)text
{
    [airQualityLabel setText:text];
}

-(void)setAlarmScoreLabel:(NSString*)text
{
    [alarmScoreLabel setText:text];
}

-(void)setAlarmPromptLabel:(NSString*)text
{
    [alarmPromptLabel setText:text];
}

-(void) setAlarmPromptLabelHidded:(BOOL)bHide
{
    [alarmPromptLabel setHidden:bHide];
}

-(void)setSuggestLabel:(NSString*)text
{
    [suggestLabel setText:text];
}


-(void)clickedAction:(id)sender
{
 
    DeviceButtonView * deviceJiaquanView = (DeviceButtonView*)sender;
    FxLog(@"你点击的区域： %ld",deviceJiaquanView.tag);
    
    NSDictionary *dict = @{
                            @"info": @"DeviceButtonView",
                            @"tag": [NSString stringWithFormat:@"%ld",deviceJiaquanView.tag],
                            @"index":[NSString stringWithFormat:@"%ld",self.pageIndex]
                            };
    
    SendNotify(NotifyDevideInfo, dict);
    
}
@end
