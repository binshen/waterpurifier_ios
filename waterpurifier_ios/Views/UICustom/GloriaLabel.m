//
//  GloriaLabel.m
//  AiShangTaiCangTuan
//
//  Created by Gloria on 14-11-6.
//  Copyright (c) 2014年 gloria. All rights reserved.
//

#import "GloriaLabel.h"

@implementation GloriaLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = FONT14;
    }
    return self;
}

@end
