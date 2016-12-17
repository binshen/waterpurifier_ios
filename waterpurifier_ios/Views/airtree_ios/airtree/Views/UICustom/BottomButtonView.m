//
//  BottomButtonView.m
//  airtree
//
//  Created by WindShan on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BottomButtonView.h"



@implementation BottomButtonView
{
    UIImageView * iconImageView;
    GloriaLabel * iconTipsLabel;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame imagename:(NSString *)imagename titile:(NSString *)titile
{
    if (self = [super init])
    {
        self.frame = frame;
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 15, 30, 30)];
        iconImageView.image = [UIImage imageNamed:imagename];
        [self addSubview:iconImageView];
        
        
        iconTipsLabel = [[GloriaLabel alloc] initWithFrame:CGRectMake(70, 15, frame.size.width/2, self.frame.size.height/2)];
        iconTipsLabel.font = [UIFont systemFontOfSize:16.0];
        iconTipsLabel.text = titile;
        iconTipsLabel.textAlignment = NSTextAlignmentLeft;
        iconTipsLabel.textColor = [UIColor blackColor];
        [self addSubview:iconTipsLabel];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
        ges.numberOfTapsRequired = 1;
        [self addGestureRecognizer:ges];
        
    }
    
    return self;
}

-(void)clickAction
{
    [self.delegate bottomButtonChoose:self];
}

@end
