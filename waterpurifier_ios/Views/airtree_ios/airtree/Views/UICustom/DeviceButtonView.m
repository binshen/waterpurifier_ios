//
//  DeviceButtonView.m
//  airtree
//
//  Created by WindShan on 2016/11/16.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "DeviceButtonView.h"
#import "GloriaLabel.h"

@implementation DeviceButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setAirScore:(NSString *)score
{
    [self.tairScoreLabel setText:score];
}

-(void)setAirParam:(NSString *)score
{
    [self.airParamLabel setText:score];
}

-(instancetype)initWithFrame:(CGRect)frame isRight:(BOOL)isRight pageIndex:(NSNumber*)index
{
    if (self = [super init])
    {
        self.frame = frame;
        
        //self.backgroundColor = BLUE_BUTTON_COLOR;
        
        self.tairScoreLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height/3)];
        self.tairScoreLabel.font = [UIFont systemFontOfSize:14.0];
        self.tairScoreLabel.textAlignment = NSTextAlignmentCenter;
        self.tairScoreLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.tairScoreLabel];
        
        
        self.airParamLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height/3)*2, frame.size.width, self.frame.size.height/3)];
        self.airParamLabel.font = [UIFont systemFontOfSize:16.0];
        self.airParamLabel.textAlignment = NSTextAlignmentCenter;
        self.airParamLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.airParamLabel];
        
        self.pageIndex = index;
        
        // 判断竖线显示位置
        if( isRight )
        {
            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1, 0, 1, self.frame.size.height)];
            verticalLine.backgroundColor = [UIColor whiteColor];
            [self addSubview:verticalLine];
        }
//        else
//        {
//            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
//            verticalLine.backgroundColor = [UIColor grayColor];
//            [self addSubview:verticalLine];
//        }
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonAction)];
        ges.numberOfTapsRequired = 1;
        [self addGestureRecognizer:ges];
    }
    
     return self;
}

-(void)buttonAction
{
    
    [self.delegate clickedAction:self];
}

@end
