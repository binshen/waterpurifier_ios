//
//  PageInfo.h
//  airtree
//
//  Created by WindShan on 2016/11/14.
//  Copyright © 2016年 Gloria. All rights reserved.
//

#import "BaseInfo.h"

@interface PageInfo : BaseInfo

@property(nonatomic, strong) NSString    *image;
@property(nonatomic, strong) NSString    *selectImage;
@property(nonatomic, assign) BOOL        unLoad;

+ (NSArray *)pageControllers;

@end
