//
//  CommonTableViewCell.h
//  FindJob
//
//  Created by Gloria on 16/8/3.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface CommonTableViewCell : UITableViewCell

@property(nonatomic,strong) NSString *identifierString;

//首页图片
@property(nonatomic,strong) UIImageView *homeImageView;



@end
