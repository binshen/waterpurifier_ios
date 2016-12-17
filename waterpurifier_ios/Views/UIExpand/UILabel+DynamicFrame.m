//
//  UILabel+DynamicFrame.m
//  AiShangTaiCangTuan
//
//  Created by Gloria on 15-1-17.
//  Copyright (c) 2015年 gloria. All rights reserved.
//

#import "UILabel+DynamicFrame.h"

@implementation UILabel (DynamicFrame)

-(void)setDynamicFrame:(CGRect)frame size:(CGSize)size
{
    CGSize dynamicSize = [self boundingRectWithSize:size];
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, dynamicSize.width, dynamicSize.height);
}

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end
