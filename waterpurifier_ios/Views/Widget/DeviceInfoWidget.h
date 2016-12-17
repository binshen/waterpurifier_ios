//
//  DeviceInfoWidget.h
//  airtree
//
//  Created by WindShan on 2016/11/16.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceButtonView.h"
#import "DeviceInfoWidget.h"

@interface DeviceInfoWidget : UIView<DevicButtonDelegate>
{

    
}

@property(nonatomic,assign) NSInteger pageIndex;
@property(nonatomic,assign) NSInteger alarmType; // 0 无 1 湿度 2 颗粒 3 甲醛 4 温度

-(instancetype)initWithFrame:(CGRect)frame pageIndex:(NSInteger)index;


-(void)setDevicePM25View:(NSString*)airscore;

-(void)setDeviceWenduView:(NSString*)airscore;

-(void)setDeviceShiduView:(NSString*)airscore;

-(void)setDeviceJiaquanView:(NSString*)airscore;

-(void) setElectricImage:(NSString*)imageName;

-(void) setElectricHidded:(BOOL)bHide;

-(void) setMainImage:(NSString*)imageName;

-(void) setLightImageView:(NSString*)imageName;

-(void)setAirQualityLabel:(NSString*)text;
-(void)setAlarmScoreLabel:(NSString*)text;
-(void)setAlarmPromptLabel:(NSString*)text;
-(void) setAlarmPromptLabelHidded:(BOOL)bHide;

-(void)setSuggestLabel:(NSString*)text;

@end



