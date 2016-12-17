//
//  UILabel+DynamicFrame.h
//  AiShangTaiCangTuan
//
//  Created by Gloria on 15-1-17.
//  Copyright (c) 2015年 gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DynamicFrame)
-(void)setDynamicFrame:(CGRect)frame size:(CGSize)size;
- (CGSize)boundingRectWithSize:(CGSize)size;
@end
