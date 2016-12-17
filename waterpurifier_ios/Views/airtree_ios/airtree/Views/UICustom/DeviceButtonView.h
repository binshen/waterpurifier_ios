//
//  DeviceButtonView.h
//  airtree
//
//  Created by WindShan on 2016/11/16.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GloriaLabel.h"

@protocol DevicButtonDelegate <NSObject>

-(void)clickedAction:(id)sender;
@end

@interface DeviceButtonView : UIView


@property(nonatomic,assign) id<DevicButtonDelegate> delegate;
@property(nonatomic,assign) NSNumber * pageIndex;
@property(nonatomic,retain) GloriaLabel *tairScoreLabel;
@property(nonatomic,retain) GloriaLabel *airParamLabel;

-(instancetype)initWithFrame:(CGRect)frame isRight:(BOOL)isRight pageIndex:(NSNumber*)pageIndex;

-(void)setAirScore:(NSString *)score;
-(void)setAirParam:(NSString *)score;

@end
