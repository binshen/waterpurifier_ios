//
// Created by Bin Shen on 18/12/2016.
// Copyright (c) 2016 Bin Shen. All rights reserved.
//

#import "WPTextField.h"

@implementation WPTextField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.secureTextEntry = NO;
        self.layer.borderColor = [RgbColor(213, 213, 213) CGColor];
        self.layer.masksToBounds = YES;
        //userPhoneTextField.layer.cornerRadius = 8.0f;
        self.layer.borderWidth = 1.0f;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        self.font = [UIFont fontWithName:@"Arial" size:16];
    }

    return self;
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5 , 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 5, 0);
}

@end