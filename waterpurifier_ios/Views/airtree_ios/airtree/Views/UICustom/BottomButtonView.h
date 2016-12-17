//
//  BottomButtonView.h
//  airtree
//
//  Created by WindShan on 2016/11/18.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GloriaLabel.h"

@protocol BottomButtonDelegate <NSObject>

-(void)bottomButtonChoose:(id)sender;

@end

@interface BottomButtonView : UIView

@property(nonatomic,assign) id<BottomButtonDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame imagename:(NSString *)imagename titile:(NSString *)titile;


@end
