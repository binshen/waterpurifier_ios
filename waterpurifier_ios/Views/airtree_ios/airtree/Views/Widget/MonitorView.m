//
//  MonitorView.m
//  airtree
//
//  Created by WindShan on 2016/11/17.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "MonitorView.h"
#import "UIImage+animatedGIF.h"

@implementation MonitorView
{
    UIImageView *airStatusImage;//状态动画提示
    UILabel *airStatusLabel;// 状态描述提示
    UILabel *airTimeLabel;// 状态更新时间
    UIImageView *airDetailImage;// 详情背景
    
    UILabel *airTitleLabel;// 状态名字
    UILabel *airScoreLabel;// 状态积分
    UILabel *airTagLabel;// 状态标志
    
    UIView * buttomView; //底部视图
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    if (self = [super init])
    {
        self.frame = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat sizeOffset = 0;
        if(IsiPhone4 || IsiPhone5)
            sizeOffset = 280;
        else
            sizeOffset = 260;
        
        airDetailImage = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-sizeOffset)/2, (frame.size.height-sizeOffset)/2-60, sizeOffset, sizeOffset)];
        [self addSubview:airDetailImage];
        
        airScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-sizeOffset)/2, (frame.size.height-sizeOffset)/2+50, sizeOffset, 60)];
        airScoreLabel.textAlignment = UITextAlignmentCenter;
        [airScoreLabel setTextColor:BLUE_BUTTON_COLOR];
        [airScoreLabel setFont:[UIFont boldSystemFontOfSize:50]];
        [self addSubview:airScoreLabel];
        
        airTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-sizeOffset)/2, (frame.size.height-sizeOffset)/2-10, sizeOffset, 30)];
        airTitleLabel.textAlignment = UITextAlignmentCenter;
        [airTitleLabel setTextColor:[UIColor blackColor]];
        [airTitleLabel setFont:[UIFont boldSystemFontOfSize:26]];
        [self addSubview:airTitleLabel];
        
        airTagLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-sizeOffset)/2, (frame.size.height-sizeOffset)/2+120, sizeOffset, 40)];
        airTagLabel.textAlignment = UITextAlignmentCenter;
        [airTagLabel setTextColor:[UIColor blackColor]];
        [airTagLabel setFont:[UIFont boldSystemFontOfSize:30]];
        [self addSubview:airTagLabel];
        
        airTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 30)];
        airTimeLabel.textAlignment = UITextAlignmentCenter;
        [airTimeLabel setTextColor:[UIColor blackColor]];
        [airTimeLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self addSubview:airTimeLabel];
        
        CGFloat buttonOffset = 0;
        if(IsiPhone4 || IsiPhone5)
            buttonOffset = 180;
        else
            buttonOffset = 200;
        
        
        buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-buttonOffset, frame.size.width, buttonOffset)];
        buttomView.backgroundColor = BLUE_BUTTON_COLOR;
        [self addSubview:buttomView];
        
        airStatusImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
        [buttomView addSubview:airStatusImage];

        airStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, frame.size.width-120, 60)];
        airStatusLabel.textAlignment = UITextAlignmentLeft;
        airStatusLabel.numberOfLines = 2;
        [airStatusLabel setTextColor:[UIColor whiteColor]];
        [airStatusLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [buttomView addSubview:airStatusLabel];
        
        // test
        //[airTimeLabel setText: [DateUtil stringFromDateYMDHMS:[NSDate date]]];
//        [airTitleLabel setText:@"温度"];
//        [airScoreLabel setText:@"25"];
//        [airTagLabel setText:@"℃"];
//        airDetailImage.image = [UIImage imageNamed:@"bg_shidu"];
//        airStatusLabel.text = @"咱家空气棒棒哒，连呼吸都是甜的呢~";
//        [airStatusImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"good" withExtension:@"gif"]]];
    }
    
    return self;
}

-(void) setAirScoreLabelText:(NSString*)text
{
    [airScoreLabel setText: text];
}

-(void) setAirTimeLabelText:(NSString*)text
{
   [airTimeLabel setText: text];
}


-(void) setAirTitleLabelText:(NSString*)text
{
     [airTitleLabel setText: text];
}
-(void) setAirTagLabelText:(NSString*)text
{
     [airTagLabel setText: text];
}
-(void) setAirStatusLabelText:(NSString*)text
{
     [airStatusLabel setText: text];
}
-(void) setAirDetailImageName:(NSString*)name
{
    airDetailImage.image = [UIImage imageNamed:name];
}
-(void) setAirStatusImageName:(NSString*)name
{
    [airStatusImage setImage:[UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"gif"]]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
