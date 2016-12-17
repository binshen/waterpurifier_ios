//
//  GloriaButton.h
//  AiShangTaiCangTuan
//
//  Created by Gloria on 15-1-10.
//  Copyright (c) 2015年 gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GloriaButton : UIButton

@property(nonatomic,strong) id obj; //对象
@property(nonatomic,assign) NSInteger type;
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
@end
