//
//  BaseNavPage.h
//  airtree
//
//  Created by WindShan on 2016/11/15.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BasePageController.h"

@interface BaseNavPage : BasePageController


@property(nonatomic, strong) NSString   *barBackgroudImage;

- (void)setNavigationItem:(NSString *)title
                    color:(UIColor*)color
                 selector:(SEL)selector
                  isRight:(BOOL)isRight;


@end
