//
//  GloriaButton.m
//  AiShangTaiCangTuan
//
//  Created by Gloria on 15-1-10.
//  Copyright (c) 2015年 gloria. All rights reserved.
//

#import "GloriaButton.h"
#import "GloriaLabel.h"

@implementation GloriaButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self = [GloriaButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;

//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
//        imageView.image = [UIImage imageNamed:@"add_cart_normal"];
//        [self addSubview:imageView];
        
        self.backgroundColor = NAVIGATIONTINTCOLOR;
        
        [self setTitle:title forState:UIControlStateNormal];
        
//        GloriaLabel *textLabel = [[GloriaLabel alloc] initWithFrame:frame];
//        textLabel.text = title;
//        textLabel.textColor = [UIColor redColor];
//        textLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:textLabel];
    }
    return self;
}

@end
