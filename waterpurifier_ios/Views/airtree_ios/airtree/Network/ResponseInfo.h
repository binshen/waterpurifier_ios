//
//  ResponseInfo.h
//  OrderDinnerToHome
//
//  Created by Gloria on 15/4/14.
//  Copyright (c) 2015年 ifnet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResponseInfo : NSObject

@property(nonatomic,assign) NSInteger results;
@property(nonatomic,strong) NSString *message;
@property(nonatomic,strong) id object; //对象

@property(nonatomic,strong) NSString *adminPhone; // 用户可以拨打的业务员号码
@property(nonatomic,assign) NSInteger adminUserId; // 用户可以拨打的业务员编号
@property(nonatomic,strong) NSString *bAddIntention;// 是否已添加到意向清单
@property(nonatomic,strong) id houseDetailValue; ///// 房源详情结构
//@property(nonatomic,strong) id HouseFacilitiesData; ///// 房源设施信息


@end
